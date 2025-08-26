Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68234CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DD76B0120; Tue, 26 Aug 2025 09:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55C66B0122; Tue, 26 Aug 2025 09:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BC76B0123; Tue, 26 Aug 2025 09:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91DD26B0120
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:47:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1790414010E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:47:54 +0000 (UTC)
X-FDA: 83819036868.27.41F8899
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 118822000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:47:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lp8EbzJk;
	spf=pass (imf03.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756216072; a=rsa-sha256;
	cv=none;
	b=2Xly8Km/pGlgwt87SBRlwvY7ibxy6UZEzLcnzpA99zOh7aa9V6LS/az2K3kEGAIW/dTzun
	nBLyLJhS7cP73azSKqhYJTcRzqgn8DCZmi5GHZwhaIg7z1ulnY/YAI49gKJp01aDuFN7eo
	h8QqtL/YE9MCbHWIGSgWZJnxgeZo3MI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lp8EbzJk;
	spf=pass (imf03.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756216072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24J6yGBtDmQ7nphXpNVoNww4k8YjsT123AiAm7QWPeI=;
	b=gktnSAp9V5fE5pn3P6DumnSayD8m1rJs0bCm+r6O5ElJcoaTjvG4uemUcd5ODryP94DYYv
	m7qTiOK62n11+W7TknnBMrEirj3yZR7Kk1tQPjEwAkR/D/BA6xnUb25y40XbhKQHsokmOZ
	eAPL3VN4IpjZ/vyiZ5QLpZUwsGz4wwE=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3c75b4cb7fdso366043f8f.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756216070; x=1756820870; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24J6yGBtDmQ7nphXpNVoNww4k8YjsT123AiAm7QWPeI=;
        b=Lp8EbzJkmAaTz4sqwH+9WpawRCPDRNfHIUye5dp0mhGRAwmjKHRYJCzYGoqLGtKoQ9
         ml8bHvVIryPy6S+KdMitr60/5Kax5aqqaBpGWAqbjuH7hIsrc2HpELxnt8tbWgycNaGM
         YdMz6WnkSgVAJ0aQKiZEdU2w8yskAs/OxawhfSsedbTEPxmwVGZmMm5hIC1TIbiGtfTx
         5nIF+RqklYgKty4G50FpDbhFqc1nCOeJGNVw+20CWgnLnEuvmx36QQZjvOtzwl0oBeaH
         4n/8KcfHu/3WrL3nFyIljHKBk397yYLdjW5ucHnpf5lXpeVG8Km0wGHEHVZq0/qF1WnG
         OQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216070; x=1756820870;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24J6yGBtDmQ7nphXpNVoNww4k8YjsT123AiAm7QWPeI=;
        b=RUwmLVNpGZRcVZujWoms79UmdEyAjMOQA4hYAYi85ukVH46t1CmN/Ki3RohvOvBCg3
         snoeEygQIt+hw3aJbjz1JBo1NbZxx0qAj15vhfC2rL0+4QLjkgK+/dH6JzuLaG/oSAzZ
         SO89LFquBe4SWnvidqBqND29//hQUCnjgQAah0xNJjQjl8KJdMtetGwD1BWfwJVjWzNT
         uotoS+N5hJzICbndb21knXppdY8nwMrwcOn919917fLYgoCHgXbwynMMlBFWxBubOOG7
         S16aWKqzoo5gfgMmeXoU2Ik3KpKoF/M8dl3JI07X7baOdAgplpxf6dAJGLyH5wI7nESS
         MAbg==
X-Forwarded-Encrypted: i=1; AJvYcCXcRHlU3ONbIo4qmqgAGG3XklpI7Gg0mWPgOeuyK+9xWbq3qI/l+GXn5sTBGqndl7XN+AXsTVQSRw==@kvack.org
X-Gm-Message-State: AOJu0YyPBgTc1w7wbYSb+mXDi3uDQ//tmRZ4QWTF1x76dwl/YM4ij8VX
	NHBT0XmV9BgdmjQpL5vpvq5/IvWjBuBkYkiVXeEHBWJ/eEX712Db+Dg3
X-Gm-Gg: ASbGncvJ1lNTFoEbWd59Sy7I6S0Ag+25xKjRraCtTTywOzgNEqpmXQZBFaJQOQCi4WI
	0ccXVWWtflOOHZodtiswXBQZmM6LMxjqxF+KLdSjjuKxcpitM0Vbv83Xqow5lRY84HKhrHxokEd
	oFlJyJ5TVofCypOc7Q1wyyat+2tZs8EOAoNWQi7Zm35WvTar/1Zuit5J8Gtz5GHwElAjkodrEGl
	024lD3SryixcAUDBXP6mBhpWMx3bY1TKtXqz6QIgP95syKsB8c+eKdClFn6DR+fk/wNNMPAUvoX
	2NL9cft0AA9Wpnruuv9iIlPkEFgj7lH6rglzv9KTHofmfcwLMmTWeX7qD/4L9d0pV5hXVYYW9Ec
	y1yH73/SpJZ9rOhTrquPFg3AIBtESpvaY+5rz5cv0lJvKk8EbU1eU
X-Google-Smtp-Source: AGHT+IGrapQhlq/k0mOQIOwdRTN+F/YHP/gq4qPni4dyohc6q+HMjbgpdtYQibl5r+Hbnhmd8Voxgg==
X-Received: by 2002:a05:600c:3487:b0:45a:2493:fcb8 with SMTP id 5b1f17b1804b1-45b517d4d15mr71555845e9.6.1756216070093;
        Tue, 26 Aug 2025 06:47:50 -0700 (PDT)
Received: from [192.168.100.5] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ea81d38sm16875933f8f.17.2025.08.26.06.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:47:49 -0700 (PDT)
Message-ID: <512764a4-611c-42d4-8b4a-2aaca4e519a4@gmail.com>
Date: Tue, 26 Aug 2025 17:47:47 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: donettom@linux.ibm.com
Cc: aboorvad@linux.ibm.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, david@redhat.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, richard.weiyang@gmail.com, ritesh.list@gmail.com,
 xu.xin16@zte.com.cn
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
Subject: Re: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 118822000E
X-Stat-Signature: jjkjd69651bpsefjn8pgmfz3odt4c1ed
X-Rspam-User: 
X-HE-Tag: 1756216071-341730
X-HE-Meta: U2FsdGVkX18eEipPN+eB6/3SKdCEp3XaVXhBO6GALSa5psNGQ21G/+X8QbsEeU9FZLSO135JuPQ9eY2Jsq3Sd2Ex1f6rxQbo31FMdZe62q7vEqprlCwnDXSRM9JmCp/7J+qZL35QTYhSQSBFtbbQWHlOV20DOBPRUjwQQVVOAbtc+kwK6PmrtBcROjE1xfHLVuDK9bKFup/MK7afBqQuW4ELoUp/7XzpdNPVotW3pL15Bm+5EAjwcpvICJjzQdk57Z9osW/O+eEcFGHnsxEe1JOhFf3DFK/NMSXauXPVpzN1lnlLSonQO+79nSBkagZOfXNpolGYUsfFoZxZ7B1kwRx3O6tlfiMDC9QO7HkC+x+bXwBKSmm9P0I/ELs2JC/oEx2QIeEBXkeSex/Mqa0n1aP/LksCGCTtle7p4F4y84TdHuN9P/YHmrjLFb5dx0VgY7msERwFFarRs+QixmwDW4NpcX/x1uLAo+Ip3GIil9vLb0cVQbfcEWGgrVBaUt8upolFaWqb8QeDaPv5ua7eqsQhRus51qLTdb+fdmuKQG6KTND0/nRaCyhksFlc4JI0KjFoF5/yYx6ANcCXTNLughXKuaQAs7I3QmFC9jKScs2pt8zw5rXIcRLKimKz6uJvz7V0YlEdKX05vV7wW921drMVrsAaQDlGhDKtCposYe5w36gLAvvAgvfdmAej6ig6/sOxruInLfe0Z8jmQPXIoGtDRCzevYoesiFCIOdDMADZBzjS+cm6wiffAnEn3MpvMHuYxVuYcNFofPMp8R2bn4UggtEIc8OmsrnpkADSXXKLlel6t4/+Upv9oVynX1M9DwKczIgBDtrCmTN7RatTxIKfzZsAeJfxw71OUe8i4eav2FCt94PYlewqc5KYasTDtSpE/+f4e81ePClqd0pcL3O8kVyS92UrB0qldfWxg/CPtmDRvZSQhj63OqV19pn4pUOPr66rdYLLVh9NCPx
 64sj+lKM
 SOS1JRXO2eOPajw30AcgvciBQL5TO9HKxEsstdqR+kH85PYg7wqphv+ST1rOMM3USm85mSexAdA0eU7ofuaqpppqffdScdGWr53DJ7kPG3rXfqg2nfeIXgOgwZoBuxkTtipC1+FNoOD9rF+PddZD3jyGyUdc80RoCw9fXz279X6CBpsh4V/7R1aI5cIk2rDnnggQWUuE9quXnNaSq0ZvBK2M1JsM9XtjtUpE3lAyBAsERC43GWadxzN2JbgykpmlevGL11zDAm1gYxWQWirplNL9rupL7PqpX6OSSbQqtYO/NluQSPI4d5oGkWBFrYp0zeOKSZ9dD6WHMlIAFsYhYePGr328sV1TaIs6WHpOBA98uckzlbFzshAyU9hZ8AzG6f9a90y/0Q7vJ9N7904sZjmEqbHVLTOek7to9AFyChu9z7hIR2zmQeFXuenk0ZU3ztNC4ng67PQ2nZ1/I/2JRb5e9MhfDric+PXWpNBvQG+vayBxJw0ratSqQyPA20DN2FDENFG/02z+FVfiXvUVTDONhYQng+z1PXp5hunAH7DtQVJzvvAiM6UleiP/1jySZnZbncY4wMs/fDXH+MhV2TDlvWlZSMn7SRjpC2XFLEW59gPd1AGIk7O8VgiNtf1d9Kk9n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What if we only allocate KSM stats when a process actually uses KSM?

struct ksm_mm_stats {
	atomic_long_t merging_pages;
	atomic_long_t rmap_items;
	atomic_long_t zero_pages;
};
struct ksm_mm_stats *mm->ksm_stats; // NULL until first enter

static inline struct ksm_mm_stats *mm_get_ksm_stats(struct mm_struct *mm)
{
	if (likely(mm->ksm_stats))
		return mm->ksm_stats;
	return ksm_alloc_stats_if_needed(mm); // Slow path
}



On 8/26/2025 4:49 PM, Donet Tom wrote:
> Currently, the KSM-related counters in `mm_struct` such as
> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages` are
> inherited by the child process during fork. This results in
> incorrect accounting, since the child has not performed any
> KSM page merging.
> 
> To fix this, reset these counters to 0 in the newly created
> `mm_struct` during fork. This ensures that KSM statistics
> remain accurate and only reflect the activity of each process.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   include/linux/ksm.h | 6 +++++-
>   1 filechanged <https://lore.kernel.org/linux-mm/2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com/#related>, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h index 
> 22e67ca7cba3..61b8892c632b 100644 --- a/include/linux/ksm.h +++ b/ 
> include/linux/ksm.h @@ -56,8 +56,12 @@ static inline long 
> mm_ksm_zero_pages(struct mm_struct *mm)  static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>   {
>   	/* Adding mm to ksm is best effort on fork. */
> - if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) + if 
> (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) { + mm->ksm_merging_pages = 0; 
> + mm->ksm_rmap_items = 0; + atomic_long_set(&mm->ksm_zero_pages, 0);  		__ksm_enter(mm);
> + }  }
>   
>   static inline int ksm_execve(struct mm_struct *mm)
> -- 
> 2.51.0
> 
> 



