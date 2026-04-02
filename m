Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89FBD39410
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FC56B0088; Thu,  2 Apr 2026 07:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5106A6B0089; Thu,  2 Apr 2026 07:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF476B008A; Thu,  2 Apr 2026 07:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD036B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:56:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 103321B8511
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:56:44 +0000 (UTC)
X-FDA: 84613463928.05.83987EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 926E54000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:56:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hNpcNsuK;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775131001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVmBc5NJuSrGcaoMZIqkBxxnYiTDtiLU9yQkm/TQaCQ=;
	b=aSRA0b4i0b8Drq/VltCVbvf+JqyL8KIoB2JM1DGYHq/IriZz2i02iTe5Ysa3EvjQRldCjj
	5d1scrMSPUQE5nNLbZrcwf3sT0U1iFTsVbxnFOtygVawhXsJsHLvuYLF8OiQ8pkhQtLoFN
	VafTI0lmKUGJxeIy2e/pA42BXa11+qM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hNpcNsuK;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775131001; a=rsa-sha256;
	cv=none;
	b=Fwv7HYI5JavRhPd0cWJueRJsT5QOV8Z0nGKajU1DMcg6CT0H3aVdVqoLf1UbZumX4pJm2g
	wrCdWv7dMjoMWmWTiHJuNdGtba93G2nhiGIp63aBCbhRgl2NAf9FWO0DRnQ15zNzgl5elA
	yTC9AfAfPRaDtZKxBvWQp/Zl18AV8SQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775131000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nVmBc5NJuSrGcaoMZIqkBxxnYiTDtiLU9yQkm/TQaCQ=;
	b=hNpcNsuK9iYkrt3xCpkYo9uAr0MEtxWooNKXizziLha/33G0e67axh+fq2huYYsykwIPlG
	7rtekQVbMuo6rcJm7g9mIn8a4S8HRNaceNJistTr3p7+s7zNz952e3gffEL3nrCf7lmjol
	OYwx2mCtWdzMZpD1JoxS9kfbTTbqaEk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-BKm6tmmCPiemgx842EKlXQ-1; Thu, 02 Apr 2026 07:56:39 -0400
X-MC-Unique: BKm6tmmCPiemgx842EKlXQ-1
X-Mimecast-MFC-AGG-ID: BKm6tmmCPiemgx842EKlXQ_1775130999
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a31df1907cso24599686d6.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 04:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775130999; x=1775735799;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nVmBc5NJuSrGcaoMZIqkBxxnYiTDtiLU9yQkm/TQaCQ=;
        b=i5ATiQ/Y8TnADvA4JkJ367nAZHOGTGd/t/oAmewSrOZyMi/taHqoH/k9BZKOsOd9J9
         PDzdRd/96c2Dc3+1d3Pzre+vSywRknZ9kyN8vofRtQHQZM5w2s80A+/rGzxyTebJFIqn
         ynUcoZx4MErqKAg7kff5VaC+hRufUcZlEJbVyvaazNe/78TbQ4c39J0WwE0WUX4Uv1Xs
         jqLKPKlnV6tRH3Yi5p/cxDBhddkymW44Ps4VT2ySK7EI+vAkMgBGiJqLD2Ju+nSjroi2
         UaF5nnFH/1fJzMRvkyRRMfU7OWrsIg0mavFHiAffMN/63qbjd/wd7rEv3hg2EJzRPP31
         2Urg==
X-Forwarded-Encrypted: i=1; AJvYcCWZbtHd74DaE+0tC26ZcUHuDPdGuvM82bOvHi+kXhvdKOOQjny0m6f4XxkKy2wB9fH8LZLnz7McCA==@kvack.org
X-Gm-Message-State: AOJu0YzdIMya3IkaBwB4vVxYwVCsClyTFwtOO7tTazfaYiCYmbAl7DVe
	TED3Hgj4ur+eMGUwLzFpBtXMHz2bpbvzWRAOSnTppU4E87MIo5aGcd0hBRVIM6JGkkV5/mWiIea
	ZfQqSkHEdtEjVvZhYjVZqWMSx9NJZUV9RiCv3aqhW5A/MQfQCajxK/GYGxNJk
X-Gm-Gg: AeBDieuq71BhrVw6lAq4Hs+jjcA650+vXgwOH/p9RpRM7iIFTKwNCOWC+Czs7IXnWzU
	Tx5vgd0tQxQFs9m1DV0RFzNDc58Na9xor8TbBCaPdtqWuBnm1T1RV46qP/OZRdZsOVZK/uovoVV
	IElCbSjLwFz5EOLrbwkqFRZxlTzrXQ5r8YEGDgVWXgk8bBioGwut5AmWgTfsSnLNsuA0bfscQA/
	I2sveepEl0m3PEXg5LnO3ix1yMR+CB7PxGs+AIhF3NtiUi265e0uhOcVpqYqaXj7k1kUkOp3kEO
	CgO4rDeohgDpMUgevVAGExP9zbI+2VV5PebN2wfqq0ZotlBKtEFkiqXu9EBQy2TDCtYgFFmGpyv
	L3wWK89aAL0ZGPbEogw+vWrcNbMGxaBqrhuu2FNPbYcr/XerVOy96ZhG0ekr81kjsEVOqUe0Twa
	LxjUVNEdGnOW4nJtw=
X-Received: by 2002:a05:6214:2e49:b0:89c:5ece:2896 with SMTP id 6a1803df08f44-8a4395a9c4cmr115458166d6.37.1775130999048;
        Thu, 02 Apr 2026 04:56:39 -0700 (PDT)
X-Received: by 2002:a05:6214:2e49:b0:89c:5ece:2896 with SMTP id 6a1803df08f44-8a4395a9c4cmr115457746d6.37.1775130998546;
        Thu, 02 Apr 2026 04:56:38 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a59691580bsm21345376d6.26.2026.04.02.04.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 04:56:38 -0700 (PDT)
Message-ID: <8d03a508-5836-4001-8eb8-b216251dc29d@redhat.com>
Date: Thu, 2 Apr 2026 07:56:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] mm: thp: always enable mTHP support
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <835725cc-1670-45ae-bf58-593aadec6b88@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <835725cc-1670-45ae-bf58-593aadec6b88@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UbcMjkO3wVsyDx9Npte_iFhnQYRA2tu6JrFtvMmC2PQ_1775130999
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 926E54000D
X-Stat-Signature: z5g49rfcxnqu4pz13ue5146wyuajs8o9
X-Rspam-User: 
X-HE-Tag: 1775131001-334299
X-HE-Meta: U2FsdGVkX1/PET7fHimA0pKxg5a/Tn2cSa2+E+d2KUErKxzOr1//vy+rStdobXB6B0DjSGw2D/J5llhLNsPDh3DkstdeNaKaMJXIu2wMtlKPbSQADjaP7MgvrmzMv8uYyXO/MkowOUQOM05++mHR+cRZmeqoyCEoxVE1PEvL3+JD++SReUarTgaq6qVx7x7N80RGQXnCLS5J63CHH5scvaaXWmOCaIhzRE1w9R970hd1qAxEvJeCmEfG/zb8DgGQcqC151G2EmRKbeoxodVdrxES5LhTU5SFEHYKtX6RO0oo6FCjejROAgy09jEmvw6fM3RwOzIrJCx5awkO2SJyx91DbNo/TpYbP8lHOZnkOWZz2aMXHPZrd+016u3HazprtwH4IEjVzy4Z1M6jQJsG50/F7cmnfMYuctUkQ4L8uxbrJG7nmcBoDpjr08MZ+KUabUL2kPe2I5Ww/ehKBbujKWJUdtt/8PXWAVkV4mQnd/IEM7rt0TGMsHseDIYMxMXalyT/8frzL2EIyXVrIUOuHfJKSwfFQoxKHXI6KBsJYe7v/uz+lRb5vTgkTS2jurcRGYHESuLlakmN8COkzTmaj5dsXM21KmvXt6+BwzspVXoikrEhKBkPN572GZ8SyjxHRbb+4r7TZOAvdWWKQ03WDUERTqt9+Ao8K4LqP2nzSzbN4ML81kbwj/tdpIisIlJNbVKTy5B7zUwm9bINyFKndBpXPp38jTNq01iK0a5My8S6iShaJ7kvKv4IbvzJIopP1R+quKrT0KdFB5HchnntPxVFH9+xa0Y9ZVATVdjMWwKvsHcsl5OgWngyg2/v5OFg0+3Jy8Ls1ZH7TXJ1UXfeZNMJa//HkmL5FYjxBeJQp3JtA7Y/ZfvpTI1QzQQGFKQabKCRxqw8K/khFhXvfbU9HZ74ryJyn8R0CN4XsmWb1FJHtnwsqg0XfEMmkzdlYh03Gy1UbiyZCX+qm7MsAoW
 SaZxixXT
 ZVtJgnCfrHgU0divN+xpp8QAa0IG7rIcfANcgUA4K4HcHuUkxKyiBdI8u7PLKdeBsXkBRrKZ0hGN0mjEHcaAxIwyua/M6qHQJvB5SswPI2Kc4z/0OPhqPVNmFQrVC0LSdIIziQ90ZyuXmGn23u77HEMzLYq2x6+Qr6ZN7MRlQLfVb5uc79yJzjfw/HoR2cOB+gcwTFve1xXSM6LgO1u4EPlGr4C07g+R2kfSdjqGWcddCPgahLBbzFnR/wYj3uUMrtIdyfYsv+7LNwprKB6KpNVWz2E5tkxAPORKSHwt9A47AmCR/xKAYBrIYFq1SZ0AfFDikKfEX7pYaBR+rZjooXa1kFwSN9yil2h/t3bCa5bJNfuhSaEOdQGRikWY3R7y5s8DXaYAlgrKcvm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-02 04:25, David Hildenbrand (Arm) wrote:
> On 2/9/26 23:14, Luiz Capitulino wrote:
>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>> lacks support for PMD-sized pages, the THP code disables all THP, including
>> mTHP. In addition, the kernel lacks a well defined API to check for
>> PMD-sized page support. It currently relies on has_transparent_hugepage()
>> and thp_disabled_by_hw(), but they are not well defined and are tied to
>> THP support.
>>
>> This series addresses both issues by introducing a new well defined API
>> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
>> new helper, we ensure that mTHP remains enabled even when the
>> architecture or CPU doesn't support PMD-sized pages.
>>
>> Thanks to David Hildenbrand for suggesting this improvement and for
>> providing guidance (all bugs and misconceptions are mine).
>>
>> This applies to v6.19, but I tested it on v6.19-rc8+.
> 
> Apologies for the delay Luiz (as told you off-list :) ), I'll try going
> through this soon so we can start queuing this after -rc1.

Oh, wow, thanks for the support!

I intended to get back to this series this week to address Baolin's
comments, but I got busy with other things (which is something I may
bring up on upstream but it's not related to this series at all).


