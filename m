Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5446CCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E318E003C; Mon, 13 Oct 2025 08:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15E88E000F; Mon, 13 Oct 2025 08:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BC88E003C; Mon, 13 Oct 2025 08:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80BA38E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:49:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43BD887843
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:49:00 +0000 (UTC)
X-FDA: 83993070840.27.F1B3392
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA5544000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:48:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sxmvu74I;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6YxR1nTJCDrfaOZFN3CnG2vV5jcoOfzGFCcTcZo0jw=;
	b=q3IKs105Bto8/8g4KHukS6dkvlVKudtsk0Z97nqrxD/3huhFIh88TN5OcRBr7ruMkkZASV
	aIpm9S9nOQIXhoeTvUvrp/gkwWazbLxFmxhFdj69jFETP4EvmS2KeR6TFHIisnWgZTC2TN
	BxyjqcdjOxEILP9oZ2qXoIUoGG0A7KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359738; a=rsa-sha256;
	cv=none;
	b=UzdMs4V4hHe5n6aZuRtosxr0BkrAcTE2XNHp0rzb8xYIO5q1+2Pv8LKHXVqjMXs8C4sdIK
	/zW5/Nh/oiWk9HNNLqlpldFSfS0U++Tcswup8Nji39nhhwmFByxxWW0BoomsE9Xb+UwRjq
	45lpIrqtMDyoIQqPjse5ggmqfcZCA+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sxmvu74I;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V6YxR1nTJCDrfaOZFN3CnG2vV5jcoOfzGFCcTcZo0jw=;
	b=Sxmvu74INfaZrxQmxI8iInl3HPg57fRv8b5e9SRWoViy3Oa7w25FOuiQYFYxR6K8pLDpfI
	QNZwILJJ/0GU9eQSBmemejDRLiaq1woA0THsvDvk2ovC4PKW6FgPmkZwEf+wrm70CjpoPU
	R6yhtMskiEWwuBtjm0kEs7iXcBg/2SU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-WeNeYpQBNt29ZOXCM9TsWw-1; Mon, 13 Oct 2025 08:48:53 -0400
X-MC-Unique: WeNeYpQBNt29ZOXCM9TsWw-1
X-Mimecast-MFC-AGG-ID: WeNeYpQBNt29ZOXCM9TsWw_1760359732
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso29430205e9.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359732; x=1760964532;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6YxR1nTJCDrfaOZFN3CnG2vV5jcoOfzGFCcTcZo0jw=;
        b=HiFJPvCjxq9z7tAMkncb4m/lV5fqO827fDIWDlqlWKmZKvPEQYrR/n7ZNqjiNzuIUw
         Lep5etEHjxM5pBayc1svbNRRD14Bb+feFCqV9WExAi/ajBiy1+//9udAwpRLZ9vBKgIw
         W5ZysedvTX8ysgygY1b8B73dTDnw14/i2RLjr9dEberorDdQnTqxdj8yDG5nhSwjs0zX
         76lgMrJlojmU/eRjXv/5ns0zcchboRdtWfPE26YfPEPb3JH+a3+nUV0q8SLOs0rTmKL+
         eG2LRC02Bi2c5c2truzvdLCQD7O6+ienY/mKLpT20ocIuKLpM6OQ/ldg6a/LXMX0Dk/z
         52tA==
X-Forwarded-Encrypted: i=1; AJvYcCUiWj1v/hyoIVGFeGQnRKhyCvBlpt5vWc+UPpz7+4E+5ocKKD70c2q1/34imQm+Cpg++OIC2qcRig==@kvack.org
X-Gm-Message-State: AOJu0Yy1mvpjlg4Czo0Y5uuLDhNtW+xbwzKujOwJ8138SUIv01zFrKn/
	fgLpoJmL1GEVhuFGw5n9bQ6W0KZPHtP2g2CN8lYj6PJtniX3ytCh09VTVutuPsCesLU9EPw5lTN
	yp8LgjMJNQmOgvD9HeaCtzOaJAebuz4IdZjf7Z6Q7yI+8QuLrsVhT
X-Gm-Gg: ASbGnctY/hi59/ccXcP0Jm5SIdlHZsi8p8qjhfWEYuTGGrmkEXXBawwei4rIXbZs4Pb
	88V4UYjtoh5Sk2AFgGJCVd846s6lbk5gafs5B+uCHapKSlxki7Q32u20YaFojk2vdNpuz2BCo5/
	aWO+nuHO5WhuAAQ2wEidrIlevyqo6+/rzGXKldvSWGhR0z6GHHMaLY4vtpKBc0CiZ2URsHRJt/i
	RFyFu4hmaCSpUE0uN6qdYDDcGR3Xj+y8bb0bglJOTuuAkRT/Xe8c4cd+hwjjIRuNkP92BBrdQSC
	McoVZhF+gA9rSRNwvt5FRKIRL0UA8Fj2QTv6hscRvJn2z9VykwUssi+9VqQA/WlLttf2HW853Il
	pLrM=
X-Received: by 2002:a05:600c:530e:b0:46e:4c90:81d0 with SMTP id 5b1f17b1804b1-46fa9a8f1c5mr144086905e9.2.1760359731943;
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGLnouyUlx2MAgaHkKm2L1dKdQ4wuo7Nrhykv7xLHekC80pf6DEJPuKh5QZvTCPV+to9J8TA==
X-Received: by 2002:a05:600c:530e:b0:46e:4c90:81d0 with SMTP id 5b1f17b1804b1-46fa9a8f1c5mr144086535e9.2.1760359731494;
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497aec2sm189420095e9.1.2025.10.13.05.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:48:51 -0700 (PDT)
Message-ID: <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
Date: Mon, 13 Oct 2025 14:48:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20251013025808.4111128-7-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JflOM_EBDEcJR1raYUcMSIFDEYYADHEbpOENaP9Oc8A_1760359732
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 711phdsemmmw6wckjzmh6mip6f7d6fsq
X-Rspam-User: 
X-Rspamd-Queue-Id: DA5544000B
X-HE-Tag: 1760359737-417954
X-HE-Meta: U2FsdGVkX198qnMxdbgF3s5T4U5PN1DH5mXNgOtaHUsGm/SzpLelLICntK/6UOSbIRWCSTE5PgNuZldsWu8nBJ5UgFLVrde9XFw2tykXsR4yG5lNKoUBnDN1z+zpdWXyuGEBzYOuzg8aK+g0T6wj8ErlFVyII4tT2cCd0T+6tdEjEzUYoFTdVu91EsllkHI6Wq0LMLGfpwa7Axxo3DEyrQ3pjzdv1nDR4EoORaGLoCqO4dt2hL+DhvPiQ9U45YzDEob6KZwYASHb5Dr0b964OiXBgU4u2+j+kHqu6rDIlIE+IyOQkpU2uT62qw7IOKs98fOZidAGPr/D5xRAriPXk6xQMEPy0x9Q08Q7w18CSXmbd4NeE/VUhuMeNK0yyTXFVY5OB2OPE7vyAuX0DKyNw6irxXxCNHsX+DwOwL72400O+GxLGnipBIcNbir3PwXoC7c1BJRIu4oSgmcBIsn11BB/nZ9iGCiaezV0rkQzkJ7WxqB0CmJHf18356I+lwIeX4mdBRfIEqfWm7kSTJESMg4y/GOF1IOctnVtlXnObVVmuMbNWWrG+le3+T5DubjW6q3R/Z8ucYRxqNmBX7gIEpSU80PX3yFZt3eyc+M0knCXzhwQE7Ul8EValK2E/m0HjJsxn1O5HX0jyU+QEt5LzgME5TkdKcKffKO8YwYji2VWArUFUSTsa9WJDU9gLv7HYGSZsuAp9ptb7AQ5pJxfezLo00SWF4G06fWXjUr/dDs+KCG4t2eDc2K4fqacJTQvP6MNULLcgOWUK8YrNxSgCcNzhKsC9h8cPxVqEo0qMlPgq3rpt7UECWGaE+CsqUlx/pabXRnXTn8fs/XeaEabxLVV23KvsVuM4o9rl71EJBwGL9z8UF/EyyqQMpoJuLQ8nfw5a4rSTUVP6CpPZMPWcjPMS4Hd/KYf2w1ko9SyWi+y9CNYx/g7nvC9Dvr0SJSNxt+Q0/eODMOQJjMvoaR
 1cNBheCp
 kC4n6b0K7UbCw6Fl4PBPYj1EWOJHtisCbkYGS8nnoPwDw39BqEDxy0C9ePQDy5r2KkAm4VlO7L8bdOdVHL7UPYB/c9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> @@ -474,6 +474,28 @@ int filemap_flush(struct address_space *mapping)
>   }
>   EXPORT_SYMBOL(filemap_flush);
>   
> +/*
> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
> + * new caller is a good idea.
> + */

Nit: We seem to prefer proper kerneldoc for filemap_fdatawrite* functions.

> +int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
> +{
> +	struct writeback_control wbc = {
> +		.nr_to_write = *nr_to_write,
> +		.sync_mode = WB_SYNC_NONE,
> +		.range_start = 0,
> +		.range_end = LLONG_MAX,
> +	};
> +	int ret;
> +
> +	ret = filemap_fdatawrite_wbc(mapping, &wbc);
> +	if (!ret)
> +		*nr_to_write = wbc.nr_to_write;
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(filemap_fdatawrite_kick_nr, "btrfs");
> +
>   /**
>    * filemap_range_has_page - check if a page exists in range.
>    * @mapping:           address space within which to check


I think there is still a discussion on the name, but in general LGTM

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


