Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A368CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C048E0012; Fri,  7 Nov 2025 11:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC2B8E0002; Fri,  7 Nov 2025 11:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F28E8E0012; Fri,  7 Nov 2025 11:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69BBB8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:07:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10DF812CA3D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:07:23 +0000 (UTC)
X-FDA: 84084290766.13.117E642
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71C7120011
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:07:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRZ7r4cT;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmNg0IbiQSMgIBfWpyOISbt53znceGdIygj3J1+GoFo=;
	b=xiKDtgN+MzFQObg8Y0lC7bwvAZwLEJu6bOiYSG1TEAOpCCxxHNMqYsAamsgrDCdHCdsPJu
	NVGEbgDRx/ID/NthezyQhAiW0A8oPd5tnCCA8RfBkThxMo0Dg0TWHRh0EdEFVxJv2sLiD0
	IsuEJac/5UdQb2qTt/pYT3pYqGsrzVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762531641; a=rsa-sha256;
	cv=none;
	b=bnY43jWmt4PvKG0u205sJUguaiJ1m9FVJ25k4iV8wqO8adFP1rNfV2isQy120taCf/mmRE
	LWJ0hI0q74nWnZQJn0/BKrRUkKBlubBTthm46PwWJ2L4mcy7YgqVWsztPckj+ASQcc34SE
	mAcApsjesR0Xpl1smych3FMmtAyf8Aw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRZ7r4cT;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE54461913;
	Fri,  7 Nov 2025 16:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4214CC116B1;
	Fri,  7 Nov 2025 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531640;
	bh=KmNg0IbiQSMgIBfWpyOISbt53znceGdIygj3J1+GoFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fRZ7r4cTjf5cb+wQfQZKSi3nxrTbj66GE5KbiX42htXpJ44IXf3nBmo+xC4o+q7TA
	 BRXzD67osZZSe5TEP3UnkDASXEMhdSAiGFcXkjedQ7CCSsHMJlwH57SJmRIb/XCc+V
	 sa8Wvr4hF1Jw3bYrpn3i2K6GJEMueq3rSmlNZQiOu89kvKXq8kl+xoD56DiPOKor8h
	 XPHuYlvf27NrmVcpFt+gtjOFbxd/4hbMJbfWr+jh5UFLH2X2tiLpibtfSo2h7LWloB
	 eGQNAROrX3tSYtgs66K6dFgmfjbzrkO5Jm79bK1xZlxpbl2e+L4DUnV41N81eAfEqB
	 gOE15k6fuoYGQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  akpm@linux-foundation.org,
  rppt@kernel.org,  graf@amazon.com,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH] lib/test_kho: Check if KHO is enabled
In-Reply-To: <CA+CK2bB+EpZg7MTKZhFtaGoYfLN5JNeaH9HDv_Avq9Qm+3e2ig@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 7 Nov 2025 06:15:37 -0500")
References: <20251106220635.2608494-1-pasha.tatashin@soleen.com>
	<mafs0cy5ub0nc.fsf@kernel.org>
	<CA+CK2bB+EpZg7MTKZhFtaGoYfLN5JNeaH9HDv_Avq9Qm+3e2ig@mail.gmail.com>
Date: Fri, 07 Nov 2025 17:07:18 +0100
Message-ID: <mafs08qghbzd5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 71C7120011
X-Stat-Signature: tede8p4j8is75d6cuzkg5kdkdzp6swsf
X-HE-Tag: 1762531641-87347
X-HE-Meta: U2FsdGVkX1+rUeaKvm3T2Ix+M3xvOP8KPhDdmCIV1Hrvh0FpQuWV7liP9fI2SkYh+1Di3ZQRS/lE5CX8BJ0Vngf1J6JlSn19kRONH3suHDsmQSDeo0xbNH7QbnWl4Srlaeydb0JBg6yeM5/1sZLilWEfZxpz4b63DiuPXnH8dYWBmd55oHMGJOKoA72CsvcSsuRFFmRbEr4Y3reoUJSg2mfH09+n2N3j9267x6aNIGA5twOFE0WOEZBa0ScXoMvPY9s8aSA3Y3d+fhszwZALysuTqij7AkD6RtplYc3L32MaobJdkY5dw5gsGb8WgCIrsNxSSBtZ9rXt8lIoJmUebI84Z9cqI6ftkrtHruoBKB0cwTAcC/Vf2XNpbVmRRCFH75FSAmVatND4XTRsMPnNjo29fHUtencBU1SSvg8BGN+CklAVT7u580sPwGdeW6hA7J6YeXdp2acZ/h/KcIjHoqYkuO4WDh9Ubp2zo04Z1WjZhW/SQu+WB8h7In+NI9gHEXdK4Ya1InC692bFII3XluPjKK3VaGJ1+NVGLDaSvYa8qL3WXWNF/FwJc9MXlQ6K0IKhNXvK17jcUEZwPF50WH89ObO6diqMV5l7OoAHZaZDffewqpdDF8xblzZHn0I2wbU6zQXjXQMB5JEKayg1x3vyTGqE3EMY8yAA2FZbdhyaFSLBn835Vijk77JcnE8o80iCf+QWdSkTVBba5EpOg2RztbvM+srJsy7ePSCkNU1I13s1R7+HBXZEgSO+PRIOZrSPOmGhgEyKd0uBJR7zLRqcgyqAaJG5eOLQTc+ZBNS91ZJMoARY77UGytJT5OOGBUNNnn15pVHbU3erf31WfGZTYPFG4C72cmAPtrfzcX/B8t/REI+zwb7uJQV8ECrLe2jSWJvpHqJfCIN9b0lAcVUikWzb5xNi1/3oIWTTzo9XOYLTeZcWhFckLKVWViGtw3eWEXCqTHXA90e9Rth
 /9sAbQTZ
 raKBkmMUycd8sTO0t4Z8PIxcYDhPww+uH2e62Cdi5L+GgT64Y940KOuCm1nX+NhfAZ+maRoqvx9M9z73dpAE6TLOW150pg+rkyD9Cex3cfSdT+HiGUvNuNqq1ee+31/lzOLTNIgNYen+abyvgvXJXBsLvieg0RmqYk3ZPYhubuFTo8bF7K/+vwZQiBT+sn1t5RRtp7wIXa2afH1zVqfPeCno+zUSjAKYQtZeGR6fBZl5AxoiqkelU5qaoltZFHeVxz1OhawghSdyS51wtWMeJOYIPc1krttBTKzQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07 2025, Pasha Tatashin wrote:

> On Fri, Nov 7, 2025 at 5:24=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> On Thu, Nov 06 2025, Pasha Tatashin wrote:
>>
>> > We must check whether KHO is enabled prior to issuing KHO commands,
>> > otherwise KHO internal data structures are not initialized.
>>
>> Should we have this check in the KHO APIs instead? This check is easy
>> enough to miss.
>
> I considered adding a kho_is_enabled() check to every KHO API, but it
> seems unnecessary.
>
> In-kernel users of KHO, like reserve_mem and the upcoming LUO, are
> already expected to check if KHO is enabled before doing extra
> preservation work. I anticipate any future in-kernel users will follow
> the same pattern.

Hmm, fair enough. I suppose we can always change this later if it causes
more pain.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

--=20
Regards,
Pratyush Yadav

