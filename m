Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B08108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBCC6B0089; Fri, 20 Mar 2026 06:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD066B008A; Fri, 20 Mar 2026 06:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C31D6B008C; Fri, 20 Mar 2026 06:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFB2C6B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:31:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB8551C155
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:31:49 +0000 (UTC)
X-FDA: 84566075538.15.8E84117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0814E180011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:31:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V5/o2O+K";
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlC/B4d37/TRN8KYlQWbS7+TjHTxKzTcsYzxcb0IQ0g=;
	b=tNfY6azt/+w35XmX0YGKlhsqJBVQR2i9fRzrHdEGoQjzJ3duNRAMPoYmLlX2iBeppi3AOg
	+IMdQf+UK17YT/VoNkAJfoxRSxF+3KGma3Im/cfTnytoRkpPR0gZr0Lg0xecPViPofMiyz
	F31N9p6J7UkVIyrTP9iE7xfd43oHlNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002708; a=rsa-sha256;
	cv=none;
	b=Wb7CIA+8Am5aWYblYx3XCQ6NqreVmC3nq0jLz1fUv2l8tB0b2izBsJd0JDzIF0KwOLgTDP
	EImuoTu3y19RA80ZXErbBNLRCGNYxIgQsOKROJ9NkzcNTBif0pmpmU6vXiLxIQjwMsqZ/r
	/cRIj9sbBLHHUis36Emk252TKL+BOvs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V5/o2O+K";
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F8C9406B8;
	Fri, 20 Mar 2026 10:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2C8C4CEF7;
	Fri, 20 Mar 2026 10:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774002706;
	bh=fdYUtgNUf1B4oA+xB5yvpsYhFkxtjq7FGYokCbIiu0s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=V5/o2O+KFWdkeRlhtYWRN5RmzMYy9awcl9ZDXj85s2SX/Lsv5/R+/Z1VyIGtv9qv5
	 /4/aUDCSgchXpXd7ZYBx7nSK6KjdY0uzfylfTX+2TzGqKKLxmdDCaawc0qZ9/BkMX/
	 btizPaUB7QbGdYHemXdGBaF/C/ByUgxDE1iPJ7S2G7a5qOYEhXsAKPikDDZ8eLmrLc
	 rS8gU9Q5Rxq1gQh2r5j4r1Wlw8EK5Hfr1EJRsjllMyKp6CzIjlvCOdHbOs2v3Z8WHZ
	 weV3XYyGAncXMdybLxGz/63VeJeZWu+MEsaErRGnMIHYkXWb0ILCZNS5bBMjplRzmZ
	 XcW8mqtKtkdMQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: viro@zeniv.linux.org.uk,  brauner@kernel.org,  jack@suse.cz,
  rppt@kernel.org,  pratyush@kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  akpm@linux-foundation.org,
  linux-mm@kvack.org
Subject: Re: [RFC] liveupdate: prevent double preservation
In-Reply-To: <20260317023834.487682-1-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 16 Mar 2026 22:38:34 -0400")
References: <20260317023834.487682-1-pasha.tatashin@soleen.com>
Date: Fri, 20 Mar 2026 10:31:43 +0000
Message-ID: <2vxzqzpeaj1s.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0814E180011
X-Stat-Signature: nqmhjngwsz4hmguoffyzdpq4fparpjpa
X-Rspam-User: 
X-HE-Tag: 1774002707-943987
X-HE-Meta: U2FsdGVkX1/irlN2M0yotccbt8lKPJlKcuIYd1EaAYf4HVGH9tcRNUwuFSTSfbakna3dcECC8KqAzA2pKBXXJJyPwgJuvgAJSyJP+Anty27n3EGmeZKzSSn8k7jBeZJKBNIL0Q7nxdiTYipiywR/LeGzcWjY7mcSbETzimCB84F8sWXZbr10cLAWDoeeGmgnNe0X6mHBgWE1M5EK3kMv82Bw8cO/SfdHH6DRYNnguvXXYk6tvhjHbSib+xDbJYBhd6RYuVP5Vz/5rTYlZMR1RJUJa7xBtIzprT1li9Ron6EmgBR/tVcmQ3k44B3i2hwnza/dO2lM8Xfk0FgxvIt3SIOnxQYF+174AjMikve4S34rZA5bW85oWPLFetBgepEg/j+7pUanDjqGcpfoEBkj+qb4eo+s+8UT0HEWTeymNNTPUKXMphU121ebvPz2oPoWj/3E5xahZEHdAduftXF4UAPfVFyyG1sctnKiHniZQjsX2RDbfty50c4sYujeOTVi+rOer7nfrOgq+xo36d3373PfYmml5VDXGuv5eIREmctM462lbf3jWeeEIpu8/Qo7hufL467od4utbdKxVwDIiIszm6hvuX6Ek6kuMjUp9hffF24WLAIRf1BzLgutfFDl7gE7fBTF4oAnf+9UDvmN30v9k0GS19M6Yzdqcahbq1E+z9KNIGaxMm+iYtcwi5D4ywVU9pwYGCTGDp8aUXbRZnn8beLCUfEK9uNLjEvsbGxOmkPcehE5CLQEeum0BkOoBxYM9rK3E4qE59GLH/y7AmpL15Y+z/TgieA0kH4Vju+68l205s1/k/qJiBDocsjx5Wp7vxM2OI8I3qvocTSGSoYhMQ0j1QfGgbqLnqD+6OuxfC0ZKrcjZd0IlH1tQK5CHyIBJwHuY7Y6qfUGFdMtQBr6+qFUspsCm8ZGBXlkxghF8/hFGRpSYiO0ww0QmFph2Iwz95nC9GgkNFj1UsA
 LrYK/AFE
 bA1VyePwUHJ79mW47MK1SG8gSFG+XEApPogvIv/qiJFK+kfnvVFgY6jGx1ERxbIrK6xYrY/vTW8cq0cJcH5v/9Uxh0CZY42RC/OtOD+mlcbgCYXk3531zG4ueO2U++8RqN+n/exsWZ1yXvrr/SYpSeRKpenadQL4icgxLi9P2Go4e9NamvmiIO8jCd+UwrGBhKUnF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Mar 16 2026, Pasha Tatashin wrote:

> Currently, LUO does not prevent the same file from being preserved twice
> across different active sessions.
>
> Add a new i_state flag I_LUO_PRESERVED and update luo_preserve_file()
> to check and set this flag when a file is preserved, and clear it in
> luo_file_unpreserve_files() when it is released. This ensures that the
> same file (inode) cannot be preserved by multiple sessions. If another
> session attempts to preserve an already preserved file, it will now
> fail with -EBUSY.

For consistency, would it be a good idea to also set this flag after
retrieve? And then clear it on finish? If we do that then I suppose we
should rename the flag to I_LUO_MANAGED or something similar.

Other than this, LGTM from LUO perspective.

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

