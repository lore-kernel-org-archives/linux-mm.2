Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F44FA374F
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED0D6B0088; Fri,  2 Jan 2026 10:33:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A8F6B0089; Fri,  2 Jan 2026 10:33:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C2C6B008A; Fri,  2 Jan 2026 10:33:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 798176B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:33:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25BD81A93D5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:33:26 +0000 (UTC)
X-FDA: 84287418012.01.BD8E86D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 189CD180011
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:33:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eFxrBA84;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767368004; a=rsa-sha256;
	cv=none;
	b=KuBwq/+Izx5OVW/iyLSOUOo7PTI1BjS8gD3p1gN5Jplf58PvfTFCI4lZ54VSN3w2nYmPF6
	X+xd1O3GrzzUrepemy2wLYMtE7umwbcRvJOzx4SX1UgXKmmThAZdk+zz30gk0A7itMasg9
	tCskiVG54NUs3FKyJoAVI3BEcORousQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eFxrBA84;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767368004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZM7TqRu/yWzeDptS/AMeKPxt1kNNx9jR2REOBS+MUI=;
	b=rMe9ihVZgaoMxKtVYt8EOK8VXJ0Eo8oBdRaleBifSx09NEjLlseXHWFsiaSPLyDbwPfm5N
	0OsDUBXXNancXRHewT0DOmexDGKMMWNjzNByPzf+UhCOwqKsAfhpTWvwAW7OEowyYB6+F4
	9uS3g3QP30NmpN0MjVYCFzj+uJ0cBgQ=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso124873175e9.0
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 07:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767368003; x=1767972803; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZM7TqRu/yWzeDptS/AMeKPxt1kNNx9jR2REOBS+MUI=;
        b=eFxrBA84nzfeKg2KvQ+gZvVddhhB6c7leR7IgLvwnTzF3fXVE+LoCfsgFGRWGbGycV
         avRvv719RtBamclkMd9/NXHlVNBEsMbiHOJSjayHaXOBpK1Kq4QuXgIy0tx/IQFhEeQc
         prT6VorC/ZR3b1/ZCdoC7jJ/W9DWzDh4SQEG/9AFmohs6bl+8ObREDNNGhJJlwcjGrTP
         /jLTTPvX9eLBYfLLR6rO2Nky4OhoxJtfmKrRP2CgxeoRaEQ+gzBhf/lOtEMmBrWXZdD6
         pHbev7G8DMfipQG9qtt7kDyhB7rYOXttdtx+j8pYhKyoznfBjsAx1QC7XRD613lT5g2H
         kqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767368003; x=1767972803;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZM7TqRu/yWzeDptS/AMeKPxt1kNNx9jR2REOBS+MUI=;
        b=Ewpnj1bYls2PmwtJzaZ9MpkchOP9yFUqRYYzC5DhlFUQxOaVP2MI/qbwSWxffK4w6j
         9kxJ76xDHfyAOlBrtnME+M7QPlh7HCq16PcUC81qpX+/fGH5d8DIX27lKbuxfGM5gzcd
         I/t8a2GrCNEjefD7YdbUuIPlLbxp2a+0WCGp7hELjmtRRgUYMqpVB8LFdD9UQbpFenLt
         MSls1umx4VMzT/rrAEBVAFPWP+5WkDEXw9kQs7JdiA8DWaSawwP+UYztv78h3QmiZksP
         tXbF9hUp3+MyQlIYTIClbnPT/rSgmIMDJzGOBU9dp5pOZcj/wzby2fJAcUhl76iJlYV2
         AGmA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ4xNlNG5TMelXuDGFdwnoJ5YZ9HcQbe0gH8sULyzYZNAdRTjiWB+RBm8nwcmn+C6bu3EIeIHV6w==@kvack.org
X-Gm-Message-State: AOJu0YyU2S2McYZcMJEOuV/FBL+mr+CguCdZw2ItXcP2jDSC3Fu6FTN2
	YnsxIuarJMhAV2m3lB9Lk10ISGDke6CwdHZPhlkFNIujxbK1jyO1eUne
X-Gm-Gg: AY/fxX6x6ok4tq7wTLGIVbVuHqCTlQj8l4gsPg/7S5SI41TTaH5byWW1EZVRw8RBLzP
	n2szxTwzXZeMhzjAiniBDbUbPtFa/stOdV2e90GFhJQQqLBH/MsE88sKuQa2K+odggvDThnzEqf
	VLzBfa53lwmRLfqpKSUHCxTmsM4tS6IiIwetdZqdzzrwdXtStN79ZGPHF2W/Os0/XePH3aH3S3W
	f9opGmRNwCKgTs/Zket916U+FQot5QEHFC60eNB+KiNCdEL8rvO6qmh59F6sGdTjES8uZ2zAzTV
	jQ4txKsUhmFLvj0W67/RJp32dloSMieoYhPSXMGJSyiDQF0U50/lMCJaBcrDqJ9dmM/+bYvuF6V
	JcPVg8azlxwuVHLOV3U3yrsHEhTeYwuYvfj3ci4ePJhK6jdM7i7larI4fVCpNPRpvZDzj87rAbz
	z/4a1R8W9CBfSCrOHT6kmOYPywRs9XjVFjAtuZVflk8RtFHjJmqqmJn8r4tfxM1YLzPr/Ni72Av
	Vr/A5BBNmy8
X-Google-Smtp-Source: AGHT+IFdFPZ9y4Ebi3gAY7G7FC7AwJ44xGEc2VCOYAbH4i07YP5Y3jFlEX44SExQe+wg/PAm5eJa/w==
X-Received: by 2002:a05:600c:3b0e:b0:47b:deb9:fbc with SMTP id 5b1f17b1804b1-47d1955b7f4mr410575745e9.2.1767368002607;
        Fri, 02 Jan 2026 07:33:22 -0800 (PST)
Received: from ?IPV6:2001:16a2:c8d2:2b00:183a:1350:d3a4:d89? ([2001:16a2:c8d2:2b00:183a:1350:d3a4:d89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27c2260sm778246715e9.15.2026.01.02.07.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 07:33:22 -0800 (PST)
Message-ID: <b1e1be89-348e-4188-bb04-c86904e61709@gmail.com>
Date: Fri, 2 Jan 2026 18:33:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
Content-Language: en-GB
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, rmikey@meta.com, clm@fb.com,
 riel@surriel.com, kernel-team@meta.com
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
 <2b315095-2393-45d5-b0bf-ea9fbecd2607@gmail.com>
 <dc7x5xq2ufanc5vesvs6ccvulfiddqjcf74r7pp3tr4bfiomib@akskveejglww>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <dc7x5xq2ufanc5vesvs6ccvulfiddqjcf74r7pp3tr4bfiomib@akskveejglww>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 189CD180011
X-Rspamd-Server: rspam04
X-Stat-Signature: ohewn63fzn5j815q9esbcimm8kbhrdid
X-HE-Tag: 1767368003-474551
X-HE-Meta: U2FsdGVkX19N2Zve9PnM0EZrMj0WClZ0G2iJcMf/Yn4HLYZ5ycD7EDyd0EhB5Rit2cOFi/hvWlkRi1LMerPc2b2wSiIYyUGAOzuSc2LpzffcuVc3DHC4dDgnIg9dwLwHPidj5DQhMJapQIsC6S6SPpmRetZisA1ZusBlDyl+i1w/fuYfDtm6O0rxM5QQQveUXqFmpPHVoBRrLgKbmKuv/R34gdgsRMH62XYUiogAHtPFxcsd7hpY3Hd5hul1ZlMGE6hlAf82HVu/xhaKkTekgNiNQMhiEw+evP+nwAbIBym3WvFd202IhP19fNGeyzsTKXiVGvecoF9C8PUDrgH7rNJwX8sxWCiiONYSXA8L5h5TzZhJT9wEtz/53VsbEdTXbYpzO5RFKqKXADKE3X43BK2NwqcgFqJBIej+ybAs6icjUL+sWALeL8tQzDq22hGBAvLqyvm2GTpSIwRomFGr1OR+FeK6ZIhOegKovSiLFv/R3jljoJJCbyx/3dVp/ylNLj2wh5SQa67Nz2veG8pjrTReCjrCgfuK15X0xLQ4c/u4/Mzq8AtWmIs+07JJnOWN+1Bl3XfWWeTWYOzB4rnxULgwHxOP3N9OXyPIYuGPKpE7nEy+GJ14uj7q0ly8DPhUB56m3+qeFah+gmUgvKme7Jfm5oGrbqFSSqcbDhU64nKzaNgkVubZ+N9S50j23Y0T4Snd3Gh589OU8KT/VYxfr+bhlDNjpwZ7NEIistYVfono60TfOVYdupTTKFZb9jYGUKUYwPuIdjrtu7UYxXuEXuI4LjrBpb9AzDeWY9yK578jpyXuS2uZBdfRgi8q1ov4FM5Glay1vnSPyIQknF6ZO6xvVWEeIbonE9RGdfEBogvL5kKFEyUm67xYBBCSqgG1+ggH9R1mmp+Hk0YWdC72lN1q9NK+3GkTV2UJoE2SNVuZuQ/Mugg2S9SvWt/1gg8n5S0CVjtRRUgxSVl4Lvh
 TBQTd07S
 mf7eP/MCK4A3bzh5ohNnZgFvm+eke6XCa3J4VKU4KgZ89GgHycDTkIZX9W+1/OuEt+eAs2EgSF9Hf4XMpqD2raMaR9KfstAhMZJwN3/vO1QyuuTp1LWJasbDGmBUjIr7RrGz1wCxtJFd0H8K4Q8RAXCDtqtRqD1jq4pZUDeE0J+L0t/uSVuBL4Su9moVsc3lnacO3YbdymYUC4V5NJ4KRatadedqy8UODudxOhsqHUTYwX8Q3GoAlRFkutsD2O1T0qghnRLahquOHEE49ibyrZeFyYyIoNNz6rt/rV2qriqrtBPAdTUZJPhe84BWJze9H9N84s+GoYR3pHkxDOdLH9fJDS85k///O6Z2Oh+Olr2E34v9U6/WYrzdIGWTF/5e5gFc2ucSMjz+rxbJT4rSaeOQgWIbJTWdyOrDkLqds8lUeioXHnHA2Zz2g0lB9D3XM5hPCGwlWsweY/Qts5jAc6/5wdIa7Yb8p+QogPN50bra7+I5yLWEurH1I65niekUeCdkK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/01/2026 18:14, Breno Leitao wrote:
> Hello Usama,
> 
> On Fri, Jan 02, 2026 at 06:02:39PM +0300, Usama Arif wrote:
>> On 02/01/2026 17:53, Breno Leitao wrote:
>> I think we should make this default if KHO is enabled, i.e. not have a Kconfig
>> option for this. The cost of storing the char array is negligable.
> 
> Sure, I can get it enabled by default once KHO gets enabled. Thanks for
> the feedback.
> 
>>> +	pr_info("This kernel was kexec'ed from kernel release: %s\n",
>>> +		kho_in.previous_release);
>>
>> Maybe s/release/version everywhere? It might not be a release, but no strong opinion.
> 
> As I understand, in the kernel parlance, "version" is something
> different from "release", and what we want here is "release". Here is an
> example of uname, which also matches with kernel source code and UTS.
> 
>   # uname --kernel-version
>   #1 SMP Mon Nov 17 07:00:42 PST 2025
> 
>   # uname --kernel-release
>   6.16.1-0_gc0739ee5037a
>

ack


