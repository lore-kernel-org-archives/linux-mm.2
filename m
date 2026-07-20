Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C494C44524
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1508E6B0088; Mon, 20 Jul 2026 03:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129886B008C; Mon, 20 Jul 2026 03:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0182F6B0093; Mon, 20 Jul 2026 03:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDF7C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:45:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45B1D1207A5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:45:59 +0000 (UTC)
X-FDA: 85008371238.01.9152B01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F9D4180008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:45:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbvIXf8F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784533557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpKzFRD9cEYof2Fp0aMJb/vwEY/DXfz3K4ZsYykrMKo=;
	b=vDAEcsWMOvo2hI7C/D65GcYXXWVzcILzykXXTjmCYVyW412Y9OvcpN/RBqPKvexzJAbF5n
	Tubtpp64Asc3blh4cpynG4GgeSRS5BKGzXTtK1ZmdyTqgXbmpiq9/gJMWM5dNs3HCObf03
	uXejEn4b2gQdks9nydAJntFOnWF8fRM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbvIXf8F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784533557;
	b=NAzLePehafhmnoiYVrzuUzs6LuQIaO5MSrLpDNKCL/udZ+/friC8Te4z8he2O10ddzfIhg
	TJsru6zisAa+k+W7jWVUUES+PbgEWvhfxog/wM8i8/QdyHg5MmG3+clAwTpP98p+Z5Tcc7
	B3fi8evF/chrAeTjixGOaSiKnycCV1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB4A3402E7;
	Mon, 20 Jul 2026 07:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB151F000E9;
	Mon, 20 Jul 2026 07:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784533556;
	bh=PpKzFRD9cEYof2Fp0aMJb/vwEY/DXfz3K4ZsYykrMKo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LbvIXf8Fv/2iiTcDlm7q1K55UXyE4WrZ8idp7iBdPhBgn8J1PHlFODmmorjFqAR86
	 YiCeT55AS9ZtIe55+fw8vTIQh8AgStnPoGdbtaEVrKomAj36wsa1ntMiZkuM8ts3+z
	 E5ef55N/JWPnvWGPgzTwQvpudJcF3dI9EhMGksGg7s5pUWxFpGxgmE+5bPeW6gFToZ
	 sZ95M3cf7IFffXekvmmvkdKS39zKpDvMMCuFRdzXQDmYZZAdAQVUaNLSl1Ac0DkRDd
	 cJ640V8jiqGyig4SZ4eZH88kXLsdoDzliRL3UuoxL09nhdO57W/+ZYl++ZEfUmtAdn
	 9TIwDXLmugdMw==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
 Michal Clapinski <mclapinski@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260717134028.2880508-1-mclapinski@google.com>
References: <20260717134028.2880508-1-mclapinski@google.com>
Subject: Re: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
Message-Id: <178453346331.1178000.18393988680596713513.b4-ty@b4>
Date: Mon, 20 Jul 2026 10:44:23 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F9D4180008
X-Stat-Signature: 3kttdpnuz959awojg73hsuxrefwp1wm4
X-HE-Tag: 1784533557-932433
X-HE-Meta: U2FsdGVkX1/2Emmbi6ian6+oJSRkKKiiVNtFXcJ50yawqP5WRWhC+hIkaMB/h8qHLKUmXgHHJJrtVXpajdxbb9tx+PLp8RCY50e34Ndhi39tVf1cEod2QSNKzWYjQkOywXY4MVC5locu6/ESHUJG0q6Nsu/RE/gVuWE8p8rharrn8w1++4VBuqPwQ2DtoPOWfqrjOolYDT65Q6QZT2ASoyqTAhRteRl4Ui7ucdj+w+FFlvLMVuz352Vx+SMLPYMHYSxY/oIgNNEQVaMMPsYCa6kDQlgf9d3e4UBxqC/zlkkMSSw8aJLifN1Azw3RFymY/4P5UHTNy6Oe3SuqYWzU0JOn+LLDMs6xi6/t/5ty3G78pNwVSA4+MCfYTvN2cQ15/fC2OoebH52/DjAqny8e3BkD+fIHOKjTGBAQLQSCZLDKlIax30PxRMlwzn5r0MXalKVlT66BzZB7M0POLYEMo9vtzViX5ToPRS/hSoVNqNTzOHpktxmx2zvKAD8BsMt6P4XJ8QCvrsatKWSmxDNqJvenwCL8/1nZ0tfe8WbYKuJEomfd4xrnrnpiMzrz0RvMezs7NYMBiYz+kkZha1I2139r8EUFqaieEkp4djcD8rPkeGbA79QZXhg3ofN1Iozimjp6tj9Zx9FN8qQ5O98y2Feo1bb2JkYVWeqPnX1O9TXzh8cd38n8Si4MhOC6C+K/7aeDMroaMC+S9pHg4Jmb24WmoxVBatNbizsEJX9Tp9PqyTeVaOlNOUohgLvTem79wd3mMhynsFtG0cTkntJUngqPoC4/M8a8qNF7eW+WIFSkHgIoWPlp7wNcJAVWR/RYyQe+6TPM5gerOLcLglCJTEa3QJuj/BkMAiK73rcIAm0qbMkGWoZr92Vo1NTydfbAJL0Hih0fP4y2ZhnOmzlh0mFs/1PrxWoa6Mct186HyvkyRmiSLLzbFSlEccQmCFLw79O1VmR1UxIu2E4sPe4
 Xp99DMGC
 E+Dw0URhEtv9shb2fbk6I8CPot8c8eezcEp5JZZI67IxMJps8oH4ZKW5tvS0v9AfYIIY7I+/p8GpMv0BccQaDOR5LcTd1wFCPEAZ9VfscKvU9l/bTA3cG437XCREHLRH3utSR7qnrhwuqvMBdM7eIeAEC9VEL4i+ojApaUW9ZSU8Ty7XuX7pL+VwDK0FDdBa6Owev26VXYW3kTUAaK5v/ceagojjrIINYpHcjVayvd5ZkNW75iwvS1I5snmt1Hz7kv5zcG62YH2BxZV0Jlibc+ylZyiBpu5nXCcU+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 15:40:28 +0200, Michal Clapinski wrote:
> kho: align kho_scratch to MAX_ORDER_NR_PAGES pages

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
      commit: c553c774c9715e1c92c48b342f30d60601693fb4

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.



