Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD50CE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19C18E0009; Fri, 14 Nov 2025 09:55:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA668E0002; Fri, 14 Nov 2025 09:55:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9F28E0009; Fri, 14 Nov 2025 09:55:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86AB88E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:55:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4143E88C4A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:55:23 +0000 (UTC)
X-FDA: 84109510926.20.727B5F5
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf08.hostedemail.com (Postfix) with ESMTP id BDED116000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:55:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="nkeSqCR/";
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132121; a=rsa-sha256;
	cv=none;
	b=K6XMDcxu5Ac/MtHJMq56UC8823MRpzLrC3kHlGp9ont17eBAGfH0yP5JJRIxOvKTqeeVgz
	sQnUCHP818BYgg1NPhH1TlWJw50jloBxCdkUISudzFQ19pnxljljb/gdxwgtWHkQc6nuIG
	Cm041x8nvb6z9bnL5PhW5mrhQR68Te0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="nkeSqCR/";
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqFB4kfwEYK3DTPTlybETeBXHHnPMh23YTwrIvvkyV4=;
	b=JNXsUxcTZn6tRQe8LviaiK0tA/D4fsLcZHHdLQgEq0LJPlIbtMW4PIO9wMbLHyDrfKLUPK
	b7hWvoW5kKi0qz+C41/pl6x6qvwKQQIPE2HS2WxHUBAOwOV5J+fss381/wBMBtXeIXZSjQ
	FUt9+f1gY4sny7+mHk91ZP9eNyOun8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1763132113; bh=zqFB4kfwEYK3DTPTlybETeBXHHnPMh23YTwrIvvkyV4=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To;
	b=nkeSqCR/TLTs7vrM6LnlsAUvZVaTK45HAsyi/8Budjh5rtKB64lvuC575NiQspyXm
	 EMuHCu06K4CYdLJw7737e01JMp4kq5Dv5zNeCY2wcjpvr7W6sQqBEGcyiappc3Fgqm
	 3uSosXZqXeOg5yaU+ByNHshDpZhXHRHirDtpZdvo=
Received: from [10.46.175.116] ([36.112.3.158])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id DCBBF821; Fri, 14 Nov 2025 22:55:11 +0800
X-QQ-mid: xmsmtpt1763132111t2xjgs4lu
Message-ID: <tencent_EC8111921B6F0B232EB2E72345EEF92D0F07@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznU0Vy0z9zIUdnfDEK8ECzGcgbZ6Ci98VU/W7VReJ3+FHPn6jssq
	 KtJ4oOD2eH2JN7PHbxoCw7ABu1iFa6jo9uU0kxmtshte/ZQLAJ0g7o7TgU0aRA9moeiVsnaMYXWC
	 0qwaGtoJ9q30uOzDpPHO7MBvTbvEy3C/9axtL9SUb+9OBa+HAZJcDA54FK+bpfBgJlCewzPh2srW
	 mM0SjrHMcSchF/T/fwHp7uxKBCxHd+Rm5MAEtq+xj/r7rFNCBqkOHNjxnH6lfqmjc+Vei3HdnyQC
	 tBiAnk8A8wVOaMpwMcKudsKICjO8wDgmZx1LjgRiZBwzXb/tu2m5EUYDCcmHwirWASIERzb8HqIm
	 SqDJbBtFzd6rZljr/MjIdmlv8kCTXgStIiI9rbqZdJCfQFedq3s0fh7PTlPeINQVwVSltZOqHYEj
	 2CemVx5MnZ9MlfJ2hQy4wuF/LeJbCt3gItkU9Ewgin5TlVifqlmDeWLuZA3c7gQ3XG6gGO78IDlB
	 /1EsZ2nng0oemHXJ541VZnlp/vmlnDGVO6sPhyKUHQ/5WYQl5hIu2aOuITc8hLkX1WV3wHhCJLyJ
	 rzzt1Yp1pMJKsQg53IQXq+xa32USBBLNBJNRCVoovWEXT5++m/5il4lozRSHPwQJU6qoR/ztSapz
	 0ZlCDyKz2Kc31bH6z4BBQxMGPKb1WCd+utiJVtIXPJs+nXQt4NIngoTCTMhViSQbQIjkralrqiQ8
	 WiYylYF5f+mQnolWg7GzWGvbkDjvyULvb+j0XmgtBK2+AvlhM2MlVwNgYdoJllHiZ94B1vumm1P6
	 CKHTQROF2mZ2CS+AJRVV8OiG60WJUMLRf+dX2bLr4M5H40Oh5D+74GqFp0uWFYM7nO1XJF/WCeKR
	 sVwLANj587nU683euKtrJWBVzKb6gf0OcFtfJmP3NbFmYzRPJr8xOnLDfItEul8VmK3msd4q5OgT
	 rAMckjbYnZAiCv0z7KfLwfo4fGAwTJod6BhnB5lBgM1kA0hKIsB+aWP0XYARvWRa18C0sEZKxbpf
	 U8VpLNS4XzfqMpwxAGqGdDvRa+p44QbcvhtZSJtAlqhsKyk31D10gPKusqYw0=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
Content-Type: multipart/alternative;
 boundary="------------j39X9bwEjv0XgVkcDQSWei2i"
X-OQ-MSGID: <585301d0-a2d5-4dcc-ad19-e255182fefdf@qq.com>
Date: Fri, 14 Nov 2025 22:55:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using
 monotonicity
To: Brendan Jackman <jackmanb@google.com>, akpm@linux-foundation.org
References: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
 <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
From: Fujunjie <fujunjie1@qq.com>
Cc: vbabka@suse.cz, surenb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
In-Reply-To: <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDED116000B
X-Stat-Signature: e8inz5i9ypg47d9mdemxmwboihdok94e
X-Rspam-User: 
X-HE-Tag: 1763132119-866392
X-HE-Meta: U2FsdGVkX18ZMYGle1BVcmvTLFohBISDd83s+bsU8UVAzuY1dPr6Z8aKZaOKKDGBDzLIfpu+GPxwdWThAlT5+dFpJGALanBKSdkkF8LgSkQj+G3XsaHo/FqReXoPDPF24k+rmDddnBgqsMzFpDxhSF/aiLon6C+tFniDJ5xM00jegMToAkw3Y06+GN9TTSvCoIFoAy2wwIRN7pXGGZxhLU3QfO2dAJB20xBYmVtSlyi2c8Oo2M1MTXDLAI781R5eC9cBFHx2ujF/w39jyDvjIn+BYeYWf7gdUbxU64SLdVb5wdqBXMgpE+dnWpfxuUxm0EJP8GALkSxWsFJm4uGKLuhd0AkaZDSmCOqexzt+dc8xdy1Mv1FKlyCKbMctamTC0EowiaZlFX/e/K+PEDJTTxVbkeuZ+R9XxHowPD3FA16KkvIkqkRmhyJPey4s/GhNYRrbJ2tvUly4YxEof4QVZidOhpKVrdnfsyeA0O8L8PnpIu1yQKf007qnHe/EyW3Ov1blRQGlF0vrM3q8O+IgwdPRreZNkCLSK9RrgyBIlO0tZLq2lOrg1Zu4lg1z/gu5Ljd71dBaz3/HzDhYKu59k+/VFGIXD16CfJnhQsX6uUL5EKl6IRka/IXMggQvO3FGDgqhNUaqy/n0ZuDTxreurcxgCp8M9yx+rhb4tG4YDbY6J7PcvG5MAggL8HYlQN7hkUiBvgu4swmRjkvMaJeCuNevHjPqZcUpNWtgINJyDA03tSy3Ej6maPpQVp3mqU9FIznlucrPMDTJraV0nyuB8uSOMExvmUVHu/2EaBxEw0FOlXgMxbehNtFvptIEQg9RTkntaC3g7SwgxEchADdRDU/2PDezKky1LBi7V3ZZXKIfHyRgZP10hhfqhcGHYdxJ31B7VNgdIxwpIpmPZxEdGY/bMrmkV6RoDBRvyfK4F92deOouGsFjwSjegVy4sQetMdT1OL9IPNXvGBNTtF3
 BukLzl3+
 eW9klwDxwskdsUjmDxnCDQcgiIJty5+iqkPwLjVig+i2rDSVlNOL4cHyeCQbz33iR4ZOkjXB28omj3exieVS+MMi+dsXSbgspNjwC0AaUZrH9rFvjdMnmqwp7LSR1y3KNqyjhi/AKYnZyshEXnGCNP49V2BdgbTMOqHhCxtWawCgRQaQiuBVi7g59mTJNFJfWVUwZIuTdWgEwvfaDpyZojJPxOji3gwqYxN3k45EY5qRDr0Ed0wtgTTnVLUW9kpTfsyOZbfWCLJ7RuyZXMlBtv4qhyMdVFlAbZWj3TDdJSaCtfBPJoPLxbELtF+/85uIgbaD2Hp0mlk5kPpDxp7/BX1HdxRLf/UsYqZ+XOUKXnPARyLqysFNOptvYG0ApBitw9ssFVnuptOv7I6KFuSWuies9+E5exYmoVYdaK1fpyFBUIdRmV4vDZrJ14JItD7yWn+h9Qo9/pKWSOMTZV8kpqbcKz0fzwB1G4Zwo55FNcfycImzdzMGvLpUgQw0caZMs76KBAU+K9w3uPk0CbGz/wEoJJzftvcH1iFCf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------j39X9bwEjv0XgVkcDQSWei2i
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On Fri Nov 14, 2025 at 8:36 PM UTC, Brendan Jackman wrote:
> On Fri Nov 14, 2025 at 10:40 AM UTC, fujunjie wrote:
>> Although this code is not on a hot path, the revised form is clearer
> Is it...?
>
> If people do think it is clearer, let's at least write the right comment
> in the right place. Instead of having one piece of code
> (calculate_totalreserve_pages()) describe at a distance the behaviour of
> another piece of code (setup_per_zone_lowmem_reserve()), let's describe
> an invariant of the data ("lowmem_reserve is monotonic, up to the first
> zero value"), at the site where the data is defined.
>
> I know sometimes in code this complex we do need these
> "spooky-action-at-a-distance" comments but this doesn't seem like one of
> those places to me.

Thanks for the review, Brendan! Let me clarify the motivation using the 
actual semantics of zone->lowmem_reserve[j], since that meaning is what 
leads to the monotonic property. For a given zone “i” (i.e., 
zone_idx(zone) == i), the entry zone->lowmem_reserve[j] (for j > i) 
represents how many pages in this zone “i” must be treated as reserved 
when evaluating whether an allocation class that is allowed to use zones 
up to “j” may fall back into zone “i”. These reserved pages protect more 
constrained allocations that cannot use higher zones and may rely 
heavily on this lower zone. Because of this meaning, as j increases we 
are considering allocation classes that are able to use a strictly 
larger set of zones. Such classes are more flexible, and therefore we 
should not allow them to consume more low memory than allocation classes 
with a smaller j. Consequently, the reserved amount for zone “i” can 
only stay the same or increase as j increases; it should not decrease. 
setup_per_zone_lowmem_reserve() encodes this semantics directly: as j 
increases, it accumulates the managed pages of higher zones and computes 
zone->lowmem_reserve[j] as managed_pages / ratio[i]. This makes 
zone->lowmem_reserve[j] monotonically non-decreasing in j by design, 
reflecting the intended protection model rather than an accidental 
implementation detail. Given this structure, scanning backward from the 
highest j and taking the first non-zero entry in 
calculate_totalreserve_pages() is a natural way to use the data: the 
maximum reserve for zone “i” must appear at the highest j for which the 
reserve is defined. For readers familiar with how 
zone->lowmem_reserve[j] is constructed, encountering a full forward 
maximum scan can raise the question “why search the entire range when 
the reserve grows monotonically with j?” That said, I agree with your 
point that if users rely on this property, the monotonicity should be 
documented where zone->lowmem_reserve[j] is populated (or near the field 
definition), rather than explained indirectly from 
calculate_totalreserve_pages(). I can move the comment there and keep 
the consuming code simple. I’ll wait a bit to see if others have 
opinions, and if the direction seems agreeable I can send a v2 with the 
comment relocated accordingly. Thanks again for the feedback!

--------------j39X9bwEjv0XgVkcDQSWei2i
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On Fri Nov 14, 2025 at 8:36 PM UTC,
      Brendan Jackman wrote:</div>
    <blockquote type="cite"
      cite="mid:DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com">
      <pre wrap="" class="moz-quote-pre">On Fri Nov 14, 2025 at 10:40 AM UTC, fujunjie wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Although this code is not on a hot path, the revised form is clearer
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Is it...?

If people do think it is clearer, let's at least write the right comment
in the right place. Instead of having one piece of code
(calculate_totalreserve_pages()) describe at a distance the behaviour of
another piece of code (setup_per_zone_lowmem_reserve()), let's describe
an invariant of the data ("lowmem_reserve is monotonic, up to the first
zero value"), at the site where the data is defined.

I know sometimes in code this complex we do need these
"spooky-action-at-a-distance" comments but this doesn't seem like one of
those places to me.</pre>
    </blockquote>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p><span style="white-space: pre-wrap">Thanks for the review, Brendan!

Let me clarify the motivation using the actual semantics of
zone-&gt;lowmem_reserve[j], since that meaning is what leads to the
monotonic property.

For a given zone “i” (i.e., zone_idx(zone) == i), the entry
zone-&gt;lowmem_reserve[j] (for j &gt; i) represents how many pages in this
zone “i” must be treated as reserved when evaluating whether an
allocation class that is allowed to use zones up to “j” may fall back
into zone “i”. These reserved pages protect more constrained allocations
that cannot use higher zones and may rely heavily on this lower zone.

Because of this meaning, as j increases we are considering allocation
classes that are able to use a strictly larger set of zones. Such
classes are more flexible, and therefore we should not allow them to
consume more low memory than allocation classes with a smaller j.
Consequently, the reserved amount for zone “i” can only stay the same or
increase as j increases; it should not decrease.

setup_per_zone_lowmem_reserve() encodes this semantics directly:
as j increases, it accumulates the managed pages of higher zones and
computes zone-&gt;lowmem_reserve[j] as managed_pages / ratio[i]. This makes
zone-&gt;lowmem_reserve[j] monotonically non-decreasing in j by design,
reflecting the intended protection model rather than an accidental
implementation detail.

Given this structure, scanning backward from the highest j and taking
the first non-zero entry in calculate_totalreserve_pages() is a natural
way to use the data: the maximum reserve for zone “i” must appear at the
highest j for which the reserve is defined. For readers familiar with
how zone-&gt;lowmem_reserve[j] is constructed, encountering a full forward
maximum scan can raise the question “why search the entire range when
the reserve grows monotonically with j?”

That said, I agree with your point that if users rely on this property,
the monotonicity should be documented where zone-&gt;lowmem_reserve[j] is
populated (or near the field definition), rather than explained
indirectly from calculate_totalreserve_pages(). I can move the comment
there and keep the consuming code simple.

I’ll wait a bit to see if others have opinions, and if the direction
seems agreeable I can send a v2 with the comment relocated accordingly.

Thanks again for the feedback!</span></p>
  </body>
</html>

--------------j39X9bwEjv0XgVkcDQSWei2i--


