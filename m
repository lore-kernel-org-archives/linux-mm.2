Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4A2F364AB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704226B0005; Thu,  9 Apr 2026 14:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4EB6B0089; Thu,  9 Apr 2026 14:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A37F6B008A; Thu,  9 Apr 2026 14:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 477926B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:18:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCD5914017D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:18:50 +0000 (UTC)
X-FDA: 84639828420.17.DF57492
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6B14180007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:18:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BfGZ17Y3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775758728; a=rsa-sha256;
	cv=none;
	b=yp85RshPR0lU2YxBLBOLE5ZCpVlxUggLtY7iYBFOWcL779PT7lVX4WSqWAg4/yn0WmtxEE
	N9x7AHqCj4hu7D52hmjmNVKGHLuonix0uaNYnv5leWH4jdlMi/fn9/T2kLkTPuCFu6ZMhL
	s+Dr4z2fol04HBBKxBcLmjRE+rMoNyQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BfGZ17Y3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4U1kjujaZVuEzwE2BZGIKD9aHE31wv2xld6lEsRjPAA=;
	b=BJAt2Kd+j9Ihm2OEfj4cii95xmLML9TGCJWFK8y1VY/AP+yxe5MQt27S/g4kPMYqwZ/NJ/
	cyxRFp2KpEmdZauJ+svkaFBeoS/kvPgBWM4H9E2tRhZgiRhteXi/R2XMT32pnpkHxm/SHo
	8NWIPxDTZJ0TGWRNmSdAwelqvIppF6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775758727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4U1kjujaZVuEzwE2BZGIKD9aHE31wv2xld6lEsRjPAA=;
	b=BfGZ17Y38NvXDEgm+oQK0f+Qb92N1VmOKCC4GSXmlx25N2iayn4YYqHygi9dA1pzKYlCCM
	zkvxaTeA7EeQljSK234wOQxZRGD46CbLICZ1ULS9xx/tt3gfssDnjUWc8KSlsPaWHHdPem
	1dEKLx9WCum835Gzmq/LiLndNcbSZmo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-HRsCuumbPNWF1fozlVWcqA-1; Thu, 09 Apr 2026 14:18:46 -0400
X-MC-Unique: HRsCuumbPNWF1fozlVWcqA-1
X-Mimecast-MFC-AGG-ID: HRsCuumbPNWF1fozlVWcqA_1775758725
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8d654ade33aso262002985a.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775758725; x=1776363525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4U1kjujaZVuEzwE2BZGIKD9aHE31wv2xld6lEsRjPAA=;
        b=F9H8A1SADfAMoNAt2++xrW46EdKcua3p2Q7V+Hlo1yP6506OMQwLdiiZflwflpUxZC
         TpKwqLiAh7FoQaINI0ke5sH/GCoWnv88xzMD+6BALNXhXOYSulTxFoE3VPXa7Sdkf/gJ
         lIzUglWcMI1x5AkYvbp2cQ9MwGUvxuV0pvfdg2UCcIbCE1HMHc7H7rqLOLASgidnE46V
         N7fos8zi7/R8hZ4uIr0mst6mJXqBkM0fXN1qcVdYr9rsT3DQx6IAN2IxAqY5rzyfx2yr
         OlpykiR2cfpM9HWRiwKNBG0gS7jVMX1T9KFlmVfVTMuMSiLl4wUvEBAoQuv2U0hCpmF9
         yMmw==
X-Forwarded-Encrypted: i=1; AJvYcCWzdT8Zt6LRsrG4sgSjKzYlW9qmKdiFCvUSDD/hOB9IUl3/SAr24ZI8y4gXp2QxGgFSR3rpJzoIzQ==@kvack.org
X-Gm-Message-State: AOJu0YxoVqRczARVWcLt6LN5nMcOtWplO4UmwOM8eTNH56xM0oLycUEJ
	YygTJoVHbr8YGZuQXxOFhQSnk41Ppc2YJM2D2UgqEeCoSfNzW33Mr8Pc/EvQifckD38pok9Vgg9
	Lcc3GtkY8N8bvZXv2LvVoWxfWvA+iLjxGQiKTB3BoTfhTNhTsG3cz
X-Gm-Gg: AeBDiesyKVG2lfbMpt3EH1NryicdXObv2XY0eBUP8YB47bLz5ho8HQMc61ZwrgG9c2G
	cCe+uV13KRDtNwjX31cDN0uOsZl81DFmGLpAYu7sHpKQb0wWP2JGZ/lkSiu+LYuj+pIqu5qLULD
	2O7V06qB+8DRc6DRcBt+qjOwRjnuKfzlzd9LpozIdhf7ORziAki/gwytZlUMepOnaa3GfCmnjUh
	70kPtA9v5qJY4naOnQiIKH+Evf1wDxNXHgpr+4ZGJ+yGemxt6u6edTc2JN9vy340vVKu945hxMN
	dXFHqNEO53OyMwMwc8JMTcvbqzz4VLj045tKo8U0sUy5bDiRJFvd5DapOLtfbKlKtVePpkBYpvT
	bXLqdg+65a5Sjm0amrJMItVM/Qg==
X-Received: by 2002:a05:620a:4892:b0:8d1:b71e:10a0 with SMTP id af79cd13be357-8dc440c9f39mr589506385a.5.1775758724620;
        Thu, 09 Apr 2026 11:18:44 -0700 (PDT)
X-Received: by 2002:a05:620a:4892:b0:8d1:b71e:10a0 with SMTP id af79cd13be357-8dc440c9f39mr589500885a.5.1775758724092;
        Thu, 09 Apr 2026 11:18:44 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb8d6b895sm12419785a.31.2026.04.09.11.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:18:43 -0700 (PDT)
Message-ID: <c5647fee-3d6b-463b-8d57-f977719ebb8c@redhat.com>
Date: Thu, 9 Apr 2026 14:18:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] mm: thp: always enable mTHP support
To: Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 npache@redhat.com, dev.jain@arm.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <20260409082936.50302-1-lance.yang@linux.dev> <addkaoz2kvfBZkhM@lucifer>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <addkaoz2kvfBZkhM@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RWDLdTQhAEKCeVDxBnruAUFtdNd79vGTj_8HFtJwFfo_1775758725
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6bdyn7pf81x1fiyd5ctrdb5kw4him5kx
X-Rspamd-Queue-Id: D6B14180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775758727-886031
X-HE-Meta: U2FsdGVkX1/8sSPA1WwU+ElVIiMf26I1icrhWhasloG3XOYnBWJ1piroh6R13mnhhiNeBt+tOzKGlF529nYit3UYOhOprLcm5CHq+CZMRyNld0KB2DKJsaq8Z5An+XeJnktv3FtyCXeljQ5cfA2IueLg8TBtrqz4n0YQzum4XOB4NINRC8hcLZywkLNzsr5MiFf61hWkDLvh+TTkqTQcDtqHmHTBPYICR3bFUj8s4KhynlG/ATzttrdor7eaP5s49mLJ4OZ5YCZfouIp+Vxzq/iOYPQhkZ74PEYB4vy8WTa+sozBIHVocdDZ6VDnNZMJj8OMZ8ikoNZWGmQGE90RqoEW/l+WUL+z9jd0F8Fbhoe7zZae5S3ShRJBsyIMKntIGfAfDZM7tx824LFPIpIoXpqmFEHFuVdukzKOpgvJ4p0vGYObV66oVtbJ5tT0CbhOrFeXLpowHZR4icRVSWNubPJbHMHiEP+UwTOjgfjKmsAVmltXqKGiGIMZFUxVaRue90s3x3lusnXKXND5F9a5+blqNWRiNcuhK0A3ty+F/Meb/votXrWV2+Xv801WEM2aJ5Ioekh/wQmooPJt0yyXNfazlwIUcU4HXdSAgxgYsyqcEFxO9PSf9HVsnXMOVaNqMtgKb/VNpfwClU4QDUBZ4WHSc2fFPUDm1Pj5g3IFcLhLm4VCf0JWx4o7mAutaUuxKuze4oj8Xxypn+WWw0H4BSEsELBwvb9UjSPwEYB07+RQbkBvcad3pcHMUpM8qq5LmXYdlED5VYnP45PDH5bP5Wui+V8ztV2USnoAVMqmhta7AS34P+G+S5OCYmrYqBeel9hNdkY4zbcjlWCps2Clvi4YNn9n4PYlqZtHhnMQnEqyUQ4qYfXsWX6W8iIyvuTLA+bNwaXtkVcsyjGvZqnAklRf5V1Nprj5B/rZ18UqJ0gHVN9ERpQKCYeDusIA0sAe5j6SmV5YRQuS0xq40gc
 dDlVdY+q
 55SZbafjRCpw6pz9GouLNNliZ5WF9yDNWycnEmvWu+Zs42dxAFrdKTeHWEL5jA/NNl2Hhbnu8RWAVYImpz6ErjFZzAaKoTfe96ZAmG1L17kER89w9L22RnibWHlRcZcn1emyPLQTscIG0HY0eTtEQyZktpUhqI+nq9GPRYEpq4gca9Jo0DstOFg9nJoiE06YJqhqBQufv6HUd3zYZ+U9fGyLJrHYsj+0JsxV7+WNQPTDnkTHVKK9wkjYGjHKuC9VBTUO9bLNWK2ZAnX9ttggzbN47MfcLB4s2/vk+Si/8C9TO410jP7RTubVkN46ZrUIQb8o6wxHbah4iRNFSLTz58o7S+1HT44Ib8CYqn7uJgg9d3yAZpGhq1Q1W7vNUo4a1uU+72aSzzdvDf8GO5t3T7IF7v86Wm+VM7d6Z714cn92mF0qB0AtguRCuUHkqu8Aw5vd5hENQteWx75AgU6rNbeZkWJUr+1P1Shfr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 04:36, Lorenzo Stoakes wrote:
> On Thu, Apr 09, 2026 at 04:29:36PM +0800, Lance Yang wrote:
>> +Cc THP
>>
>> Some folks seem to be missing from CC for this series. Please run
>> scripts/get_maintainer.pl; it's your friend :)
> 
> Please also use ljs@kernel.org for me, I'm now ignoring mails that are sent to
> my old address, so you won't get replies if you send it to the wrong one :)

Thanks Lance and Lorenzo, I'll make sure to CC the right people if I
need to post a new version.

> 
> (My upstream bandwidth is dramatically reduced and I can't justify checking both
> places.)
> 
> I will try to take a look at this when I get time, but really this is something
> to queue up for next cycle clearly at this point!
> 
> I really do appreciate work that pays down technical debt however, so just to
> be clear, I'm glad you're doing that :>)
> 
> Cheers, Lorenzo
> 


