Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E51CFC271
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 13:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A856B002A; Fri, 21 Nov 2025 08:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBA86B002D; Fri, 21 Nov 2025 08:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA046B002E; Fri, 21 Nov 2025 08:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0430D6B002A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:04:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF31C1605CE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:04:23 +0000 (UTC)
X-FDA: 84134632806.12.E66304C
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id C58B3180017
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:04:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GLRhU50c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763730261; a=rsa-sha256;
	cv=none;
	b=3zzvmIHDTTv2YUP+o3bqIhNikT8O6tJJDXMV/jz3ALa5nT7LMLSV0mYN/qSiHgzjjvVgQS
	Ea+njsYJb3AiewX4tGmGlwjWiOrIawE5xD1WshfVyjGgyc6dp2tW54ftx1czYcdZcsZVcL
	fAJGfKuX325jqw/3D+kaarTXhF35/u4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GLRhU50c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763730261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hGhb6xgX2y8Cv4H8jg13ylU4BfkqOlg8uqpNi0jito=;
	b=e21PnY0vlpX5eseZydV68GcGY0bLltY223MC0Ewb7CgGyt4HjTV832cAWUmj5kB4AX3Yeg
	5EyDCtLYNgZLxilwXhjkmu9nzfjFuJrR4l4VKnlvPFMiiCytpibWv53Na+XU1dHKdhmr6R
	JiXr02N64aNvPjDzdNynuryutzFGt0M=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-429c82bf86bso1239337f8f.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763730260; x=1764335060; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+hGhb6xgX2y8Cv4H8jg13ylU4BfkqOlg8uqpNi0jito=;
        b=GLRhU50cLQA89BzwLHSn93mlKasVKQgRpivxj2LNVwTylP5QALrwn6EI+juWD2l6iF
         m0rPvIHSLS0YOW+nogM21CRA1hWqjyz0FAED/DYrb75bmNgqL2K9eV3LeXIlBUSYpalZ
         0jXylp+4zYvqUOwmgEfsmS7Yo5ler2mzXurE6xWVubo5WROyPSVzNsGH8B+ubHr78V5t
         MjW72yD0B/DeMY2hOiHu0Lkp3yMYSkLuNEWLyFsDB1v03ReggQ2ElEG1/t4Jn+weCyV4
         sbCNHJ0M9qgKKe9O1pBvUNQyqf5mv83FpSQnJK9SdICKHEJoGFVVntckCLb+9JFGMfl5
         hy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763730260; x=1764335060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hGhb6xgX2y8Cv4H8jg13ylU4BfkqOlg8uqpNi0jito=;
        b=XKfjLtuMNGmlj9BgbEvdqljF6dTZFzf4Vyq2N0MPM8Tn5r0VNW1tRTKPh8D3wUfqsw
         6TCwbeXh5dTBkVgfcj7zrL9VhiyiAhXC9G4Swvls10HiW9tSdmZQZ43HwWtCxtWEc66W
         5pKt42EhkXZGCSVOFcbvPZoM58iDoTcmslk7YWTTakkMfIi/J1Imo2zJ1rTvJGTlAHIl
         TFt3maywMUy+PTvRoOTeH75dsxwt+8VptMzPOMcf1t6EZyUna32MSbgTmjNy6fGL0+py
         6WhJT2IcoUjQ6D9bipwaCIwsaMg0LFvCz9Z+FZ9k6Wr2B0QhP4TKutsdNc3Us4kcener
         ll4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrtKmY055SAj8EeqlsqbZPihOk5t8q/tDvsMnux/GNa1Okk9EzLBGKsf8CVPM8gsByyOBcQMFuLg==@kvack.org
X-Gm-Message-State: AOJu0Yy6VcRwve2eY1X5FPW8/NG/ookeAOr+ffQrXH5RXYfN1FhNBW1w
	es9AuXSPzIEMhQXC71XMzxY11KNatxAtDuQbtLL2MVHc/932GuzRg26l
X-Gm-Gg: ASbGncuZHpe1n6J1LMjyB98JgUVSMWUdZsYc6IwFf0dKD2nUQ6eMYQxEIFhlWagdjIv
	BZewMtU+qPM14/u9f+DHt9xit2M4aZ+16c1WV5cnGzGFJJXAif8r3zDNkS9ETRdztxv9SccokB8
	w140od+Dh4alhbzdtsbnR2E35cSG6HRG5dRqkMgLENTcfJ/jUmPAXQd2MP++bjF6FAI5Y9xdCXA
	MFdoUsQIYbOfDWEv7NofX2dtlf2mwS5OumNUVXHNqJ1MSh3KSDa2OJREgLfY9N0HWM7cFs9gPgt
	3ldfHhcf46LUVeBSILcPPeEmMK0kSbpR7sAVFqE8BQNufCglfaifsQtYjfVp4eOkr8mYDlDgT0P
	iPZcd9ZH5dq94+m1iRLXsBg2ez2w6Mda7z2pSLRchm+/qilJRgzXHHHFcbzkzAgLIRTFVOL0c1z
	wSRL9vPDTRpz5fq0nn3PtKbImue/89IUdHn0mxXWrzsBo=
X-Google-Smtp-Source: AGHT+IEUyfkkATekh7ulM7LuJzIlOC1XYWL+JvSgyjtOyj7Vn540ELYt7m8DbsLt3VH5KIz9Q8D7Qg==
X-Received: by 2002:a5d:64c7:0:b0:42b:4061:2416 with SMTP id ffacd0b85a97d-42cc1d19643mr2343892f8f.52.1763730259856;
        Fri, 21 Nov 2025 05:04:19 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:813d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e598sm10743641f8f.4.2025.11.21.05.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:04:19 -0800 (PST)
Message-ID: <1f13f400-206e-4ea4-9225-079672626024@gmail.com>
Date: Fri, 21 Nov 2025 13:04:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] netmem: remove the pp fields from net_iov
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
 dsahern@kernel.org, almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
 io-uring@vger.kernel.org
References: <20251121040047.71921-1-byungchul@sk.com>
 <20251121040047.71921-3-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251121040047.71921-3-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C58B3180017
X-Stat-Signature: ccpc6gtexyt9od7jaws6jp8e9kur5pp3
X-Rspam-User: 
X-HE-Tag: 1763730261-643161
X-HE-Meta: U2FsdGVkX19troN8bAp0MvPmJ545qMXgqEfiiRSNtyYAYvDaDmpxbZTwql1LNh5t9iXvCiyjJIoNkv0QNQOPtUYE6C0NH9pJ9w7n0osFeFYH8HxaugPH/hR47JH9QDiBYOhfpw/82nfRlpAil0d3P9XV+81Q8sksOr8Ptva9brg06hnEdBi5AGZqKC5Jxq0YS5vV7709gUQRpZv2YSkPGhgLV+NMxlSxBB2QEEoxqcv/5wEQtY8iAp5fUbtslN5U1ALJjdxDe8797ZlfeMt1UXmeXJxRbhScVLriaKGMATAv+zMaOVl4VRIFQIkctOSSlJnJVc0UyGcXv9+j7l6ohEg8Dg9DnPXv9vDml8w7idIaE93+coz2OXpygtbX1OxsA8ZOLBqZGtCwrDFiwl2WKAD2sRs8SJgJ9T4ba3jiWSNbNbnvmko5QccrpE+2zz3TGfp/y5opYehCmq3uOGcqJnKRb118XE4bFxPdK76FNJSMa5L/OtKLRpXx4JkaDXJ6HrUJ/xvyjzwo2pvIJaOcwVfqpcehbOhWU8mS5dp+IesZ1zvHfQA8+ahCF4J/wOYiromqlCBYlNuwZbLd2iOMKndaYAajK4aoFZb0ncLVf1yF+9Fn0W4imP8CgEvg5gyvodPm+9ZkuabmOaRQ3plaTCHFXnPV7LIV0DFXCv4T2s9k1SsTrwBdvwJNL39iJWkNaEyirJ/lFDdGF2gdyoKLri5WyNJnBa6YavXBmnhGCxAwSXqKRY4cNm3UVQrxFkDEKLYy5ED2qyQ4ZCbDqAYrS/ZDp5HCdWV3QqOqe4/PcLZJsA/fcg5z9LUI6UkQZ/pJV10St3YyIAfMgjCD105aAMk+xP5OIbE7zrw8gfOVQN5u8oDuNLwrle6RXoEIQtkDtAeZ0zyVC5A4I1OCkKyObVUvRJCGk1O7ehwEtzGZWXb4xSW1zxLHH9ZKcr3DtFTaHHgy21Nf2AY3s6H0kXL
 aH+tBXiY
 oq+zvMHYTCGSD5qGuzPutCQoXTLdMpEOVO2yI3GKmMEWHeJM9/GAKzAYVvI7bG4nceqSp0w8vIQ+rmfJqTkqwXwTOgnSwHntZwYLFJVnhffqivw/6mukZDViBOuqkdQIy9GIdvMaO5kfcx0PvvoGXJS00XgVeYJpJ9RtMpUNqf9SAgpo/GVg586WYkTl7Iy+ikNT5HRdcSZpBoZypwYogIp6HuMo325EPZH2Xro553srAX60CJsmhnxrSyUNEiW5BCtXnMscdLT4mHvfQZRvtk0j1K/TR6FbOSx9oOx3RL7rFP3XrdcZ7SM76D/wVR563pEVPEO/Tb1HIRqF5pvcUAhdaM3JXJ1TIprkY+vYy7xrV0BpyEPwL1AReQp0L6DzQMwu+uSZVbbLiv4PfWEOeHMPjr1ba/LWpuUXMhtzEDrMj0P0u32z6a/l3HgmZHM9bFtkPEODyRkFtqvLdx/vu9Ph1dqUovv8Oe24uOvSAYdGfDDdzc4SYKivNw6DdV61Brb0YdkeqJK7XE2jtDIh5YQZaFpG9lSz580oWYfoyjp/2mwtx8dM7FG0yIhzB4/y5CGn7P4Iq+C4V+MJzQ/3JSThSZFGYp5O3Vi/4cAcq0tPAxAfP+oPA8ZiW1DUqBdwdx8O0jwTv9lWckusS8iT8RIx24iE11j10DUmRilc0cmpDYE+Iux45fZ2K68vr9Y0tNgEc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 04:00, Byungchul Park wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>   include/net/netmem.h | 38 +-------------------------------------
>   1 file changed, 1 insertion(+), 37 deletions(-)

Nice!

-- 
Pavel Begunkov


