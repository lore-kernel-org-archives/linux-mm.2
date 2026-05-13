Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2187ACD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FD76B0005; Tue, 12 May 2026 23:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8406B0092; Tue, 12 May 2026 23:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EE16B0093; Tue, 12 May 2026 23:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE2E6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:10:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B821A406BE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:10:30 +0000 (UTC)
X-FDA: 84760918620.29.1248B6F
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD2A32000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:10:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I+T9lujN;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oih1vGFPUBDxQAv+CL0VvSovowAL+VrF9OkYpIDCCNY=;
	b=1SqG850IfHdnFal5ItimxGMFBL9ECMCM/dcPEFIKn9XBO9X9mBEa9LE3t1vZ6wkzYb1gJ1
	fwG7zmlsDJu0sK5U11MGvKyyZLsW77Z8ldFHeEt2DOYDGJ32gm7Q3QMzsfpiEOq9xj46+o
	UG10M4YvjWaMwnJcX6zz7YJwLmCYTPE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I+T9lujN;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641828; a=rsa-sha256;
	cv=none;
	b=lAyXEsVIPloO+Nn42xOPKu1Hp6imHpSgMk5rZHhRU5Dy8C5fCDl7jOAWYbMFtDq4QDWM+r
	wX2fDhppDj4/P6jQyqCrvdSkmSDynEAJ6Rb9kJxvG9jNkJFm5fgyOR1+njN1odEUn4XHRC
	0sOYJ9Yy6uEG2EEwIIjx1DgWe9g6p1k=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2b9ea536877so36589265ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778641828; x=1779246628; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oih1vGFPUBDxQAv+CL0VvSovowAL+VrF9OkYpIDCCNY=;
        b=I+T9lujNzYkd4CybmxfUGQgW5YWJBIdXpxOGQEBqUW53Ri8qDA+CZH+I4blB6olroN
         e1a71WTwSaj9r+snXEciYMYUAAj0zBX05gwpeSGuI9ZTHbyu1F7uCyZemctOTaBqJyWn
         CGZNqMaXUCQTW2/U/a2SLQCMYQOqZO/HoYIFaSl2WqdYeYACF2fZ6eVDdkdqWouQCE9O
         K3nsiG+AKEdVB/rhqhYQlPtLFMokBr4TIlQazlKsMnDchtblmGqoVvo0fRCxzN5TBdsw
         RpCwzst2rZu1jw4VZzNvdOkFed60HpKxfdQ0eXdDt+uUxI4RYpJdknZT2LhEIooEFRzo
         dGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778641828; x=1779246628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oih1vGFPUBDxQAv+CL0VvSovowAL+VrF9OkYpIDCCNY=;
        b=p41eMVHXkE4AE7tzdS/mYfF48qdGr0JJVaFwr0u5yHHYLSC8aG6YnJOw1ckBFOlg1f
         ilDDKxVuPraCaK+EKb0tsup0hW09mYuckCPGmS+K4U1+VDCCKmKI6fhd1iVFrDS/tVMv
         JS80j1/Z11zWOSWg574Sey7Ecnt3WvJW811f/iLGphgDZol0rHZRzKUi7NVzuR6vlSOJ
         D3aVnFCfj/Ia1d0DGG42rYHzoDEDa3L/FMQ5IXYFUUItgAAsVVHmksA35Uz+g4fdSqC/
         8266xqUwQaPtrJ+K97ekD4Lawfte7XlIffbXdXEGkWwo0p4neyQ75IvTfWHaXK7OScb6
         Tazg==
X-Forwarded-Encrypted: i=1; AFNElJ9rqwWrzfxOIrJxGZC5E3+j9m9KpRZWZy7j46uvrHHsERDnOUCPVPTIT1zecOy19JGZSPHe1yfeEw==@kvack.org
X-Gm-Message-State: AOJu0Yzm/25e47KeIDiSSkqE3Bz3c43RMLPVu+REzBEx2EZvx1YY4fDs
	DReLMaQehX/noKXGjHsYWxjr1MBEGIbZMPjB6djRS8OC//U+VqJ65St7
X-Gm-Gg: Acq92OFEfJ6yxuqFUM4HWqtmEkwWu3E+Quya6zKtp/xvhi13hBUM+ujw8Dq5aUngxxH
	yl57sKwrJZGV/I/6OBYXNa4Tk7zphhmtHHYm/OuQFhL3wt+kq3Xy3/FuTqpfC+JUISTqwpUJJZO
	/qGlsFwoUcOlLMQr3sCltOlZi+lfBbyVNinzNZW5tOjQ+Av7ZaUUfU9rJxJjA9wJK51pZJ+9E+4
	iuy68/JBuUci/UAuXtTFEhsvAObC2abj5wGCtgsMi5f8fxJnTwAdn5vq4Jg+0GbmjfFS1IelaLF
	6aL+DFHS3ifhgicfOSRycRq2UsWpItacWk8W7wCtd/Cz/MjHVDfaiVaq9hNbjcle1JnCZU9zaKQ
	xbCBttAt2AEc/wUPXiaoAt2m+6YBX5cd/My+ffNzfqzOxyz6pQXU/F/C1n/w707N7oy+4OPB1Lx
	Wdz8MiQJsC5z4HfRRPDSMWfTafj7D45Ck=
X-Received: by 2002:a17:902:b713:b0:2b0:6068:4c5f with SMTP id d9443c01a7336-2bcfcc3ce55mr40588505ad.8.1778641827542;
        Tue, 12 May 2026 20:10:27 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d27049sm150785245ad.7.2026.05.12.20.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 20:10:27 -0700 (PDT)
Message-ID: <85de3792-596b-4efb-b2a9-89556e098f01@gmail.com>
Date: Wed, 13 May 2026 11:10:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: avoid unnecessary #PF on mTHP allocation race
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20260512095031.1333997-1-chenwandun@lixiang.com>
 <220524ba-e39a-4d7f-b44f-d4e2e7132397@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <220524ba-e39a-4d7f-b44f-d4e2e7132397@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD2A32000E
X-Stat-Signature: c5ozzjgxpkbthi7bkpjsx56wffedgpgf
X-HE-Tag: 1778641828-416248
X-HE-Meta: U2FsdGVkX1/+9D2mrDQzNuS1Un2kdSVvdprO3IAIwDccXP0d/d+FFCUdp8R7hdOx8t33G1k+qwViS7/WYmSZ5RO9s1McEglh0Y2W+yzecbo/Sb/5i0Fe9zFwy8L/LfY32qdUoPqES0Il3j3BXPL1IpcLF+LNbcPDxqvrFvAdfebtSdAmQ5y72LP33H2y1+xNYmz+tg6C/Fosa3nXzUxkbGeDIReSWaNjNl7pFw/PMFw4xZ+AkOQ+H6uQD8fEl/rsoRMX9I/u6RFubnBcD3Wd8OTX6o4dOk7/V5wCCBbOvjr3MlX/FV7jXxJswwkTeuo2oQkt3BFsE/gSCMb85/1g7iG+OQpxF3xJISVo497eATD9W2iS8kQcTvpIA9jvfg+QBjh5Dty1TiWWOL84Cpukeh7QFvbBnmwZsvDQ2B9OSZSWMKuyu3l0q0VO6g8z8RKAUrHUke3TjhUO1FajEIFBHrgfS/7x0gnSC86l8obB+i0Kq30HkpQu6jyz3dlYUGsgpqzaTZFhih6ygPn3H35pJy+GILdIAJ3QuOF1MWEFfd0B1XjDPr+g1lZh5i+OCrywxDIz2xtvQIzKAEvKvbqAeXxH5i965hr244VA3bbJKExt3b9aZw5V0X1qs+ju0FINOtKuyFg9b1Vp9aBjR9j8klDgCvH7i3Wv5zBLwEaPOLqiB7JJlmFmucfgE8E4hvoZGIbnX8ofXrGTfLBH20NLj2fqZUvpAezgPD4vFt0WtLVAaNtzc4l3/th54bgTnRAdv26vkUvWFE+Yh03YzFImf6HyQnGHnSopw8w0b1DlT15rFGOBkwHSxjkcTMsZSLjt6AFLV7HEPMt2AZlbyB7F3SWprPrRBECKdRA/6pB9Dk4SSAylJEMn8dZk95zMVnCFm4rDYD1vGTHxzaGJ6v166YaXwn3aGU3OUb/YMdOMrwQzgURvVi4CV0kVWRYyDW7fJvyVFXX/XYRPsqPegxP
 4hO39ZQE
 1Cp/ovu5Xy59eTHwUDcmZOu6Ei+AeG4ddv8RHLvO33sA3KD8PAJC0cBzK0G4EAAIuL+SSyJ9fYs7uFG0qTrastiU1K72MdX35zST6t5brkjo0xwIFOALdV9N1JK1Z0dfGkqh6HN1V326oyVJEkCXzHRMa3BcfP1t//ESIHwnFUWS18bbkREG2wCzIGabzFI7AQbnlBehgn1zmG0jOsyci4FwD6Ur+E9P1lWJIyS9yTwm+gs/i0UuyaKyxuu82n2E6yD4V3otl19kJVDhVh3T/7p91+10GE8PQlMAY0OIrSRwj9oW3MCftAEbq1IbviY/INPJbwhaulZyVI8y/0REmTcSc9Z/gJDP3Y0H8qzJx4yx1Orxa/vSABq//8M+tQ87W61/vnJmFe8dNsOiBqsK6MJ9s8SuGCiwfQwp6LgszIzgoSy0k4cNwiF2cT0kOGXROTHqsAcyQBc0lPyun/EjaXpJcPDWZzvHyeANq9De/4yWsE2nWbg3TSuAKpOjYGXDBq5jgxrSZvTXZpwjg3fwpgm8D1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/26 18:35, David Hildenbrand (Arm) wrote:
> On 5/12/26 11:50, Wandun Chen wrote:
>> When an mTHP folio is allocated in do_anonymous_page() and the target
>> pte range is not fully empty, current code would release the folio
>> and return.
>>
>> This results an illusion that a page fault has already been processed
>> even if the fact is vmf->address itself is still pte_none(). Another
>> page fault will be triggered again.
> Yes. Why is that a problem?
Honestly, the only data I have is the reproducer; I haven't been able to 
show a measurable impact on a real workload. The motivation was "we did 
the work of allocatingan mTHP folio and then throw it away just to redo 
it from #PF, and this #PF can be avoided by adding a small check + 
retry". But as you point out, the second fault path can handle this case 
properly, the behaviour is already correct.Please drop the patch. I'll 
come back with numbers if I run into a workload where this race is 
actually hot.Thanks for taking a look. Best regards, Wandun
>


