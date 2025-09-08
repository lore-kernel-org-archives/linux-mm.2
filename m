Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E0ECA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5DA8E000C; Mon,  8 Sep 2025 14:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356668E0001; Mon,  8 Sep 2025 14:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7318E000C; Mon,  8 Sep 2025 14:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 102DF8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:45:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A198E1A026C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:45:37 +0000 (UTC)
X-FDA: 83866961514.07.AF79B9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2873A140002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:45:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eGzUMi/I";
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757357135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZ1U0+nto9ykqfQPo7HpxxJzqiGtL77TvIiUKaOMOeM=;
	b=yJ3050ucY1Q7cFfpCi9GQK2CwSfnk7zRPzQZ4yZj3Syyq1VXmgMOnpYSf8iXV/9UAxf1sM
	TMlksfRQcCHIamh1UVFx4/ZiIP3LXewdDJtwHHet6a4r86igmmHyW4ajqjiKmHjEEodcbS
	5jkozvSwBZyX5TL22AndJk0VDdCGYdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757357135; a=rsa-sha256;
	cv=none;
	b=wKqSNUpG1JF/F8uZqKlbCnOLu+E9wbAPFYwjTx7hwdcW5GM8up43tqZKwwRbLLtUQuQbV8
	qodL37DdF1GdjmOPef4BqnnychMG2FQpgM7CsOE4PNGQ8NJvREdTBF8K8RS7e6c24KEA9I
	NwGztFcXbC/UjCGF/EXIMEj9aloKlR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eGzUMi/I";
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757357134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CZ1U0+nto9ykqfQPo7HpxxJzqiGtL77TvIiUKaOMOeM=;
	b=eGzUMi/IQuJBO8SqQHIOzY2X8bKPZwsJSWotFnHOwu6hfReNDpqdHd/lgglp0OSFXzwdVb
	pIRYRUKbLKx9pTJrx9apsDAWvwcljqqZbFRjSuZ7g2kRIY32u37wPtLMepegQIDMvnKEOp
	0Nu4f2XMUa4M3svFVSuxPVdMs4gxkJA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-HpbmwQ7HPnC30R3dFqforg-1; Mon, 08 Sep 2025 14:45:33 -0400
X-MC-Unique: HpbmwQ7HPnC30R3dFqforg-1
X-Mimecast-MFC-AGG-ID: HpbmwQ7HPnC30R3dFqforg_1757357132
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dd9a66cfbso32655435e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357132; x=1757961932;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZ1U0+nto9ykqfQPo7HpxxJzqiGtL77TvIiUKaOMOeM=;
        b=JIVX5fMGo6RTtK5T7pYMn9Kh/aQd2YOy+Ab+ZqEdpPdP7YcSMRfSPTTl7Tg8F4nmCk
         O+l4evLVZQfgg2DY7Yxg2b/dbprDSi+pXo0kHsaX6scBt7bFXMNgad2+5jdRcx4HRRCQ
         l27Iwo4/gp6WNcedG7ih5T9rB4HGz3HZWEL659lPco9sR7QVhmkp/ajRxFm2zAlmrAAj
         YwQGJ7mirCPvyXm2ywBHrbzYc/HRaNO7smppBLLkeKCQ/0aB5VY4mrM+1gFX+EslfXvh
         qzYJYCRdh8Adh+M3xuYLH8DlcXKQyxZ4lyQouTvPZdfat/A3kpf635/1GNSgkYKCbXbX
         USbg==
X-Forwarded-Encrypted: i=1; AJvYcCVx8uvTSRguTzLKt1fSIYev6W/rcTEmnLfSPJMMoKIETS2dQc0IDmNH6tZZh3UJIrQso+HQPiQG+g==@kvack.org
X-Gm-Message-State: AOJu0YzGkR1aJFR8uYcemGtVXHiT4Po8rvo66y8ck2CLhM0Jl5uaK3Q3
	Z1Xup8fWsooVN806y1zZgi2SrgE8fg1H/DagHWRcMRMu1xfEwlR70/XX4NmBBR5OZ+qbiE0mM3x
	UZljHGaZxcFJDtI2hfPobi3CRRWlOfUq9Q1oD62T4wUbQiQ4RKqmW
X-Gm-Gg: ASbGncvi1FyWSsmoWcLKtSZfjeLSRK/lB7++H+O9Rv4un4cC/dAA//wEM/nYF6nTIqR
	yCU7Kn2nhoeeCFY50FVkI3jLfaCR9TQ7x2mr+m+Xhp6mN/pAo1p4VAeXahtoo/tNVpBoWyyoKSO
	nV+FIeBMLSLuCLmjegrjnJkkO+macQHTevzp4JkEiC9IREyUgjDEU5bOq3UzTQ9aoe3Pp9qnbV9
	UiR+h52qQe2Wi9D0jcjlvR8ZJRpgz74HtFDFXls17oqqDN4g5eDaqX40iJm7ZNc5qV7zdJOY8NM
	JOVUOYUzZYw7i8FBowXvB33D4LLHXGQIh/alP3LUOoyas7p057YtuWhY6zn+rOW2dDPLY/Z8fPu
	n0AQRYuN8JWyiVvfy78Jr0ySP+mFUOZjsp6qM3fZlxBu6EzpNOIpwRW74fAdx8PpE
X-Received: by 2002:a05:600c:46ca:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-45de072e878mr66056915e9.13.1757357132101;
        Mon, 08 Sep 2025 11:45:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl6W6PZgDJSOeT0hvE61lJkei0qub4EjvxomlpdB428UuZFOkk6zMkWPcWT58RiDXm1V4n4A==
X-Received: by 2002:a05:600c:46ca:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-45de072e878mr66056435e9.13.1757357131588;
        Mon, 08 Sep 2025 11:45:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de5180623sm34433125e9.0.2025.09.08.11.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 11:45:30 -0700 (PDT)
Message-ID: <5c43116f-fef9-426d-8c90-1a3a129f3d20@redhat.com>
Date: Mon, 8 Sep 2025 20:45:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm/mshare: Add a vma flag to indicate an mshare
 region
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
 bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
 dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <20250820010415.699353-7-anthony.yznaga@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250820010415.699353-7-anthony.yznaga@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I_l6kgChFD-vJCs0oguKDl1wp2tc04MiVeiIJTCeTw0_1757357132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2873A140002
X-Stat-Signature: y7conimpg79cg14r4mkdm47cpk9bussu
X-Rspam-User: 
X-HE-Tag: 1757357134-690597
X-HE-Meta: U2FsdGVkX18XdldoZ2EhUTi4QbLuKCajZUMNRhU/Wbtz3md6s03PPJDGXMriWffqS87p37Pgax9BxaBLm6yLAqJjf+qYb9lK9k6G43cpiGODnM8RC5ROwURA2Ucjq1YvQb85jm1PzB2Ek8fbJZ0xvAVE0CEGrFcIOgXxbuyfGBIc+HkqUD82kworQwVYln052czVwlbFZhm72e9ou5L2qvWpYGDhjOVrjoETNcO1Me8BaVABKxHcjE6VGtdd4TL4TLYJ7Gp2xLiGEX44ZGmNBsG397B+gxwUDXq30iAzk1w6K/8DZvchZCNO1+ltx0W4tbaS2FtNXstTFa5ECKtKa+wuUHftirp32cgSyMLirFg58KenCMbJdCQjWtjNavAC5yFyzgftg/TEcu9EnpJKr+7Hf12KZk/CCxrpw1t/WcDRX5em804SSIItIWksdS0Wmjkxfu+52Z1d8cLrhpP0fC7OWA+ilFcd/K0q8qdS9obKBAV47uQOhFq4DLnak9nuVmLZVMs8n6Tcoby6EpuTIMrJn7QuHSdyUQ/1IpwOAAGf/USGO/SPp5QdtGmh4KBTjF41joDcDlhQSBuqrBUdfK5HL6+35LXr4Bvhz7QypQKTH79B9jp/EDIS9Eyps5siyVJnHHR15sEf5uCOivfdXPAXuf/ll7/tJRcBN0MaTG3jnm+EO6A0I8bwC4KH0imvN8YweUnaXXMj5Ul0mGieUnDs6L49HAMPi0S0253lTLCaHPozq++PM3pSIicqkP2DQz4K+NI7i4dLmgcXSKtelGpckOrUkrZqIpzlWZYQ/AV9Qq5ChrYAk/vQ4S0sSWqGzgt69BI5eh4sV0TlVc99f6zd+HmKkFdRf0VnPIpWfcpIDSmruJNln/CLtLIJjnHLf3ooQD1lLiNO1o3y6bvHuRla7dGHRGASMU00EzTxF581sdz7sifpvWNNHaTxUJdnyFbwfhmvg4pbosZ6CrE
 zF8RzKlw
 8/fI3B7uOV+2vm+Jo5o2f/WaNqmZ1b99YC6XlBM/xYK97Kc/BMq+tF6Xh7Er33HGYzl2FY7kZ+MGaFMI4p3AOqrhqWzjhIW6PpvT+yl1XQ3LwFCGZ6iYYu5a/vsWTvmJJ0fTWb6DIsKEsddidTht/rETlBeELG41GmCafM4nJFy815ygzmx0t4xPFunNe7X0SxIDPkifYi0TL9bA/86eOHH1kkegrNLWsa0onVAujjNedRvi6mxWtHdzkDwx6YeHUNm4OX+5+2z5UYVNlDP56W1/OuzC0e/aQo7XTT86J4Z+fAO28PO17p1hftXsWLZLvjMPfb5vt7up1NlDSk9MUcbvs6XY0XnonuHBwX0dI7lagl5GZRRdbhM0TQl74UNRizEQ5HjHGAABTt8xT/64+QerkkdihdbFHvFafrZUOXIRTdthGOf42/A8B5tZQCDQ4z0D0FLNGnmUVWqAlew4F1x64JlfiBbt/mRKmb1j88Hju8nH+RnB03JTXSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.08.25 03:03, Anthony Yznaga wrote:
> From: Khalid Aziz <khalid@kernel.org>
> 
> An mshare region contains zero or more actual vmas that map objects
> in the mshare range with shared page tables.
> 
> Signed-off-by: Khalid Aziz <khalid@kernel.org>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---

Why can't we query the mapping instead?

-- 
Cheers

David / dhildenb


