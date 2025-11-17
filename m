Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DC1CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71B48E000A; Mon, 17 Nov 2025 14:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22328E0002; Mon, 17 Nov 2025 14:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B396B8E000A; Mon, 17 Nov 2025 14:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0DE18E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:14:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 608C24CCD8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:14:43 +0000 (UTC)
X-FDA: 84121050846.13.4F9CB2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8F1A140006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:14:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMBjO0Vh;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763406881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSrsmVGMG/dH5pV7vpYI07R1nDX2OTiZVYLV3UjtgzI=;
	b=boquIX5iCcV8Z+0K/KMQfgsJIDKY72TOWWygulZPvt7nMrs6nGvGcAXx4xIvKamJq5P0U1
	G4EWMi2MrWV8ensGCzDmdFlir1uBTO6oHIFH1Xe12twzWE6XRXVcZqfTrhO1sK80cmO5jo
	e+ZlEf8MZ8pbYCQ54bypQDAEt44DvF4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMBjO0Vh;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763406881; a=rsa-sha256;
	cv=none;
	b=YoVyOGTg6J+BeqtKvt2+g6yNMW9B6YJdbBmzrqEgNZkifgPjyzNSLOTR4qpJOaysibbg3I
	E2cskBKkakMIsdgiOjJIbDVxEpeac0s8D6n4U2PTKLVBPyI+EQs04Tv9J6q6ewQ+qTrAX3
	fEqRUT6X0YLCLW4GlZOIS3UwxCAtvDQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763406880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSrsmVGMG/dH5pV7vpYI07R1nDX2OTiZVYLV3UjtgzI=;
	b=aMBjO0VhPp78nb2lPhb3tIDxtutMPsiBp19IDLfapIYgX80I/Cssag33Np/D8UQF8AUrp3
	QnOGiR3++DOFRE2HrXMQ3lukWn8MLydQW4vMRh0Ve6bPXq6/yrS8Rrkqj6Hpl5WJgv87Jy
	bSwUn5QLCE1QcT7dVQCzOpshJgRM+QI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-1wC9OEHyPT-sBvwfKf6fIg-1; Mon, 17 Nov 2025 14:14:36 -0500
X-MC-Unique: 1wC9OEHyPT-sBvwfKf6fIg-1
X-Mimecast-MFC-AGG-ID: 1wC9OEHyPT-sBvwfKf6fIg_1763406876
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2e19c8558so620218185a.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763406876; x=1764011676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iSrsmVGMG/dH5pV7vpYI07R1nDX2OTiZVYLV3UjtgzI=;
        b=XZjHTYmSL8Ev1gQMupX/jPBwsE/W8zd5oylGUMme4YZuZ4LfttI0iTW83OGiTOFRt+
         dct0oAt7V+gURbZh2x7vJUrJLc8voD4Z/yXGv/G4AJtqiNSnvnTkdksSnzCLigPAeIjd
         ZJc3XUBNq+uRdMjJrbguZ6xtH92LhrIkIkpeL5P0SzrgCPn6/eRF4UZCaPn8DVX1z/pH
         MsmorXH8WGlkg91Auny27hcyyV5DiE14+Y7trJFrmvl2Q+JlT3x+ttVzwRjhgrKEVnxq
         N/d97Hom9/rTXpIRSB8NaRiBi7V7xpEpQfD4uJ+sapq7nSPc7+zMNmyFFHF4uZeiduH3
         LhuA==
X-Forwarded-Encrypted: i=1; AJvYcCXZvDcmLHp6kL+T6kkhWOOynBQSUSsAl7ehmNp9J2G+EoVPy9z90mFThSrzCxCNhYUi3Sbya7xMjQ==@kvack.org
X-Gm-Message-State: AOJu0YwdDC5gmRJigemFe/j+sr1ELV7YnS6RaMB5XQLriiHOpGzopQdS
	L0xh9yvomIL5/PZn6U/EQl2GAIbu05k8jMYMjl9ubyQxVHREYuR0N/oE1Ad3ArdQ2H93jdt17MT
	JXN6XZ0jyBE9zMm8Vb6W7WbqdLE1E6S2DBSiszc9ce6CYYK39OhyU
X-Gm-Gg: ASbGncvbwVSKvxLXeKK21MRuXrYYnllXPb1msz2UtR1QA6pNICVpmF2qakVIznunG5f
	EUikWoUpKZ0pnPZfXtHnNXRpO6DbkbWkB+fzRkvLpazLDYudkhmHWfY8RPaaZK4Iat26T8NqKdQ
	boWqO9umesPN+YgfVF00Rl2jkHlaf57Fcc6C7o0AV2485NXpvuEet7wSDEDWcpcMFvjWESIqZQR
	p3a0uM7jfjjo26HL4Zeuj7f15CG3cuk4ydCDB3a1pfWzw5XVIL88GT/PHUm///c0JDEV+RfVa2i
	YyGWbaiJdZ3curxuWAD048cTCekC5cns5IxqE5kdDJ7+lteawlNmDcgxGtlswV7MT0PiA1YS3di
	WGO6icHeCoSQ=
X-Received: by 2002:a05:620a:1729:b0:8b1:c1d3:8e91 with SMTP id af79cd13be357-8b2c3178d19mr1738642785a.39.1763406876330;
        Mon, 17 Nov 2025 11:14:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2/q3B59EmoCvNB8WeVVgKLrAWeE303DyiZV9/PzyxspbhzDKscX/z3D01hGybC4C2+16R5A==
X-Received: by 2002:a05:620a:1729:b0:8b1:c1d3:8e91 with SMTP id af79cd13be357-8b2c3178d19mr1738638385a.39.1763406875859;
        Mon, 17 Nov 2025 11:14:35 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e7f63adfsm414761785a.11.2025.11.17.11.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 11:14:35 -0800 (PST)
Message-ID: <79c6f081-f670-458e-9916-0f8ab501057a@redhat.com>
Date: Mon, 17 Nov 2025 14:14:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 09/10] mm: thp: always enable mTHP support
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <e9a6a123a03a122010cc10708391db901b11c7a7.1762464515.git.luizcap@redhat.com>
 <dac20466-adac-4e47-8f50-87f4774fd57b@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <dac20466-adac-4e47-8f50-87f4774fd57b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 70uH61Sbxb55oLig2tXosetfnsepgvLPMD_OZUqO2zs_1763406876
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8F1A140006
X-Stat-Signature: zam3pacbwsnthcfazgui4onfghgbn4ey
X-Rspam-User: 
X-HE-Tag: 1763406880-855097
X-HE-Meta: U2FsdGVkX19fgJ82jPsP6O7aobXSRY8eDAfGJQ/v9Dc3mCQChXny9499fTujlZ6LEtYlZKRMNpjFntvxMq1fPbmdNj1C5JqASBU9KC/FT1xOfxH7z6ZfjXvkNYvxvUBYi8AX8J+3krCSvE20AR/IDi1PLoOl0gnsYdZ+pukab2gcz7QH+fTvYM/zWotdHcx4IvBrITo7aTpwbjErbP+BtJr0ioL0z44KkS0xe/2583EIfDSNC1rukkf+YXz1rnIOCbewLuGANsN0aTvk5KWd446AzqyW+i96HUIG0Zy+AjJ8G49LWpX5kQMY5RRScOnbaLP6gjumXkaXCAw5/Mp4ZO76yrSvblJELmkdXdURrgCk10yATXMVneHar6HyQRabUP2LeLmNq49CgCPwSLTymSOZUAcjmBa6nh9UdsZiLzC3mLjteP/7k864aImhVIFnXHwSN6v/qRU6p1tVIhBqyH6g5eT48Sr3lSVrERp79wm2FaAojmbiRpLFeDp2zQTl37yOhFqCYqrI90OTXe00MKviJ+POeA6bol2N99L1ancetUWje0EUyWGbTAukox7CCDUKe8JQwO8bB4sqERbkxd3KjVbuyqMIW49iEWvp+ceqgrvAnHxJLMMtK6J9FR1S3/N7VWdB997Q3IwFnbYoYBTDyi7bp2oUWCenNlTDujmzuHJBMQaQd3Vf5CzB2tFv87Ixe1PsMypDB7wfAg3MI89ODM3B22q40510MavqK6P+nIBlHdsHePl+lRilnrIhjbWR0UCiq0IVJMGrsBjT7lhlnDryur4vyAXhVMgpUjv3kQ9LD33A/GjA6TGA689D8EDnEUhyPHFlBA1VhO0F3Na2rJk66CB0yIbpvDM7sxCZcfTAzmbLL/1PSh2koLDpVbL8OE+5EcqGJnuFsm7tp5R4dCklaHsTGTr/akh+eky/Smio4WhN+dAIIj9qJJ8MG3RCZyU2o7cy0P+6e+N
 5MxEUHyI
 3CNAWYkb2UTD6NC9GloPoB2E1KyId0ZnS+lqG/r5mcmfiHW7Va9hmJ8dIOT5q0UMZf8ivbt1Xf1cas8W4nX6Mq1Bt8Z8GI94CYaELd64dzphyDq/BEsB0Fc02jdaMny6Eni34UUVqDpI1Y3vRhpqe/7Ql1vpL7DS77GmnpE/KH5LRZewmZe1VkPhj465ZRORZo52nBCChxbhenlZESRLgtjVlmHw7afPP7bN7Tz0WQzWVPEL97XmlUZKbrGy7YoBLdHj2ZPzPHYh2vGdl8lcxOpLQMN1ojzVlrMSNC810Qsi3z325m7/yJnK04mH6ZNMXdecyMdrc1NL6lZ9xKQvE+2tkTOK2cmdaOwjo1C4U6b0qULzQej0eFPMIuEt1NCqPmYBRYSkUqoPd1mDknHe3Zk4DrOPuKTkadlN5PIw+q/Y94svoFv9AVmfTQHktmBGzzOkBLYMYBToSbIiwRngqmUP4+R5KbmlNIpPj1wzYpJgVnkBNN5aHMCxn1RQC2SS860IBiqP9myMh7sI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-17 12:47, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 22:28, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0f016ea7082d..4117833c53ef 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       else
>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves())
>> +        supported_orders &= ~BIT(PMD_ORDER);
>> +
> 
> Won't this leave PUD_ORDER set?
> 
> Ideally, later we'd also have a
> 
> if (!pgtable_has_pud_leaves())
>      supported_orders &= ~BIT(PUD_ORDER);
> 
> 
> For now you could simply clear PUD_ORDER for now as well.
> 
> No PMD leaves -> No PUD leaves, so clear them in all cases to not leave PUD_ORDER set.

OK, I'll do it.


