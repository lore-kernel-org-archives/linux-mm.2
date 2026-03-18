Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66072FCD0C7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA676B0105; Wed, 18 Mar 2026 03:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7ADB6B0107; Wed, 18 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91796B0108; Wed, 18 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A64A86B0105
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:38:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 392301B845A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:38:21 +0000 (UTC)
X-FDA: 84558380802.15.4B253C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92B8420004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:38:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V2Ntsu55;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+1PtHO7XafJ4+tno0nEJ42Yea56SZCwQqlQY5+EWik=;
	b=nen+q99PgZLOnJFcb4ko7s4F10RCPtSAa+0rpjsJ65C9EmGkrUfl5RhPNTDUUm+cREsWBc
	jY+I7LyUaFQbvNHPnv7nWNbgqqUOhUk53WJTsjJyzF52GMuQlIdE0lske94tIbTGSoaCiU
	+2gX8IoFWRqYbKzXUW4fxLhWruMx/+Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V2Ntsu55;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819499; a=rsa-sha256;
	cv=none;
	b=HAY84K+uHpgYvWcCRoPxJkQdgIa3UFd7vL5yzz/xz/wywguNTTdYTnZNlwTHgJ4ZfzoRlh
	gptP42iUStI1slZmyKUDQz8m7ZfC4XU+HU7Q0Btfm0tdDYFdBu1IaIQMQgU1/lC7zoON1e
	haCzeUbkzU4s6sMWn02QViwp7V9gDvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16CB6600AE;
	Wed, 18 Mar 2026 07:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB500C19421;
	Wed, 18 Mar 2026 07:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773819498;
	bh=lAavQhWxUHh6y2yrdQoAQfAj8drjCm9e/GYE2XSeyn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2Ntsu558QoaAICbByIqy4hCtufSKkWV6RFmG1v8kx6g0jX9Hz/4QP0+X6T9AzipU
	 CKDO3AVN33S9phh8FfX/0ip8Xud2JKQ5ExMRmOoISNcBXJwvji+L+gQLKAPiEXGJ4V
	 4tnEBnp5UrfwDTfM2qrAv4PN7paoxM2XD4WlBSYM6Ouifp7bLgpY6TJ2/PvujZXAR1
	 ewvYRtBHPkDz/KJ7MaMu7vI1Z2uLpAqJcfCZec1jog/ndCZSvAvfxjHHjm0NdG8jbo
	 MgumssLY4K/0BfZGf1IA8juJI8omzcWinfh3l23GPlbPOSU82T5BYW4Y7YnTMOM4vo
	 Jv8TnATToccdA==
Date: Wed, 18 Mar 2026 09:38:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 5/6] selftests/liveupdate: add test for operations on a
 preserved memfd
Message-ID: <abpWZZWaxUVg1HYd@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-6-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-6-pratyush@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92B8420004
X-Stat-Signature: rkkp69n5uojw3oz99og34f3zyi1n4dcj
X-Rspam-User: 
X-HE-Tag: 1773819499-233243
X-HE-Meta: U2FsdGVkX18xT+LUPPl4+BeJf0wtsutcz+Alvhbyi3UVE4ZHX06GhaIydpJrtfHifmd1E8KYiMTAY+MRjJRyCqQxz0sShIVysDAYo4aQorMLxizcIX4y4zR5rB7SWu3Gt/8zzQw/CJezepumEG+ELYSPjrXc1c5t7JgIEGLCyqiDPVjriMBzcWtZU8jEq7Fnki0jv+qGkZDeGndMS9iqCt4pd4OK/vqxf3Snc5hzYjVLUbXJkviNrPOg/CFzoGZKLOEO5fnUpo0KNhwW5YKLUIJXQJixxePMvmV9r9cvK6L7aTIJNXRpxp/hQpfldG6k+UYt3ycs+hjjV7BLh40INdJCRBIf/MbQMXhx86NijaBOYCORMiJaBftii6Z5B6BU9suEqwQbGFjVTrksyD+xlYOFdwsZLoyNNp+vy6WdClTkQ9hZqx0Vv6mbHk/kN3gjiyoXMYATqq5eOxE3TZLkUpkkhkeROU6Lodak4HoMLHhp6K5jd+i4f3Vz8LMivxGGuvAeKJhMMM+DqDGoJzW8lyEWK1KYPjsNb7pBYcFfmdOIoTE01dxMhPtMT1qp937IXeTR/E9cbhREHAp/DsaY+Eg6XgorQeMlULDTbxHIW86AwI/iRzvgyF++3zFNeNjRimELdEnSNS3ssQ1p621nrvxmGnB4gND0nnw0nFVF8SYM5TKQ9dCphL8EaOiqOFKsIKX00WL4/k61DLCsRXEJa+3PKyf2gj88LfwM9b5MM0O8biAWY44mY/85hnAUsaReJD69rrxQVk34U1YKeXlLz9Xv2IrH2GY8sJ5Hsu2nD8/jMEEhRo7xWsKDSpKHmxK2eAWZG6LywbOwWd+6eeS+rVrAMDnt7LEX+LzzrJpKGc4+Z/z2XoGyrDbb2ixBcaTpk61+6czrBfoPef7UF18FIdHxzQRdmiecDAaC0++IY2rqYWcLgYOwnDQdgf/cRIEJwYWSst2S2KogY9CnZI7
 j7FJlW8Y
 PSP8tqaj2CDV+MqcHu32wHmA+gYly4042xxr2QXOVFuGgMW/ZCXdUqV2T31oWg+Rjor9hU+37ZPbQpQEdLZlsPcX3Nq/3XAYemX83Bp6fcvbdvQXhz/EfGOIhVSCOhKnr/DlukA5n2OilBmHty1AVUUL5vIlA2l72XKgnvUucQ2boqqS4dzZVW8cOEosKhhnHz3rQ6f9oG5ZBadT+b7oljm70uInndqUkJl4GyZ7HdyrvCEgj8IcCHqA+JJT48yrCIBn0hkZWpIUBE7K84rRfsgmjgr8kHy4ep+EQtikzhiFP/TD5MYr5D3Z95Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:38AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Once a memfd is preserved, certain operations are not allowed to
> succeed since they might make the state of the memfd inconsistent with
> the serialized state. Among these operations are truncating or growing
> the memfd. Writes and reads to already existing memfd should succeed.
> 
> Add a test that makes sure a preserved memfd does not allow growing or
> shrinking, but does allow reads and writes to existing memory to go
> thorough.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

