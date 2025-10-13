Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A06BCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF5B8E006D; Mon, 13 Oct 2025 15:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448BB8E0036; Mon, 13 Oct 2025 15:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310108E006D; Mon, 13 Oct 2025 15:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B89B8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:59:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4D83BA57B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:59:07 +0000 (UTC)
X-FDA: 83994154734.27.DE842C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46BEAA0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:59:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cmc9LjBo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760385545; a=rsa-sha256;
	cv=none;
	b=RW+c2pFBxIUnFF1WPzNMjvlqYSQy6G9AgxzxUeganvKaZAYU7RoxfsHvXRtj1o2KHFpLdl
	cCXsyWD6+yGnmggKhaDemDpbJ3tUaQN2p2wSwxf+lfjx58TFDgMonHz7KFAsUZK93Tomwq
	EosGrKUlWkf4Rj87MsMnNYt0Ry+q4bc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cmc9LjBo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760385545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNYrRRv0UVpj7OF83STXMa0S0+9wdXsPDfsjLG00SV8=;
	b=AZxBjNSPMYOppJ+BfhHRhIAQeTB46iKzpcoc6HkFHprVLWixLLtMT9R0ZJAYWYBG5arPaV
	VcbWlG1LZD35sEAfs9XYaExPKafGgoT2P07vGDnL9xXzcalJL4ND89cXQAKwGtOHbgwdRi
	0NSwIlJlbqodGzRoum2x9Tct9cPU+gY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760385544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cNYrRRv0UVpj7OF83STXMa0S0+9wdXsPDfsjLG00SV8=;
	b=Cmc9LjBonBvpFliB6f1FJXLiyiG2JL6GybmEcI58gxyIWan9nNI8GE9D2YmPk9uTBFiptE
	bT0VTggWQUpor1RTyWbEB50nqxx6NfFRI7nkC7j0TWUaE3sC7HR+6zoQPI/OH4JGzZzmSi
	tO0m9vlMt08ZjYVKg3So6euWh5ycQDY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-5b9RKKffOXK6VdM3CvcIAg-1; Mon, 13 Oct 2025 15:59:03 -0400
X-MC-Unique: 5b9RKKffOXK6VdM3CvcIAg-1
X-Mimecast-MFC-AGG-ID: 5b9RKKffOXK6VdM3CvcIAg_1760385542
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso26315955e9.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760385542; x=1760990342;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cNYrRRv0UVpj7OF83STXMa0S0+9wdXsPDfsjLG00SV8=;
        b=E7bczEHlYJX13PMut4w54mI0wN/mPgx6pg2mTbveIfj59+eNKnTWKhFAcgff49Yq03
         XWqt4P6ik9qDNsqcj/3uCM18hIiTr5CkF+8vysV/w3RYZbDwshxM/WWHPRsOA0PF656i
         29TMXFYGms2+eMKUr2nE/hdYrbFTNnIBBqeDxfDK9fTFs3YXoJp0X2HE/zcMDr1h4+Q+
         Fl9UBLizxY8LU9DiMe7a4QWhBpJ+R9Au80AvhrxvLd1As6EcDD4UIJ5r0ZrTV0E0GFl+
         +h97/HqhTyrRqa3e2EAHy2bqoJf7tLhx4DElXDoTwhSrIoHylx7s/HUMUl5wEN27v1dq
         BkWg==
X-Forwarded-Encrypted: i=1; AJvYcCUleSaEpXSipYm4S/xJ0uGV4/kvtW9ketTykDrdSFYgetCd0z0UIWh2bb8+owEyY0dYqQoeIwL+rQ==@kvack.org
X-Gm-Message-State: AOJu0YwfFLS9GFw5kmTlHMlNJUImLJG4dFST/NCnevWC0iWJyUokXtrg
	vussGT30rERY/FrrC+jNSiiuUQC9PjiI0Jxc0Y3VOHxWtbODYk/x0DHHON5JYcKSjdgVqdshCxW
	ZIN/uXsnqXMaGAJDR6++GVJCSauGLaunWUFTXmu84Qwlc1z99xUBu
X-Gm-Gg: ASbGncvH+DVQHCOUDBPcpT8xGiSjvSwDvj+ZfGSeg4VuMSLC3cXjMTsUcqOLeDes08B
	9K3RN5zosetanQA/ixZM/n0uN7kEKhW9XphqUkeJUJNL95dJFObsSaEAyJ+JVCW+fq/8mM3wHlx
	cIiBsMX4wCgmm4O6z+u/RCyn1T2rF7XrvLnnUcCAVpAMrvBcWHLkEnt80iwEFbWn0K7uPzON7JO
	39e+oq+Kgun7ObkUEHxJLoPD+784UKassSePcCzMmrYbO7t1G15YoSjVDyzC9MxP8KU0EtR/LoM
	4JFa4ZM+bm+m71foXqy9W1g7zZLNEv0jYgRjNc26AnowcJvXcdTbnaXwvCAPRtP61I0SeAEHmF5
	Sna0=
X-Received: by 2002:a05:6000:25c3:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4266e8dabeamr14498752f8f.42.1760385542145;
        Mon, 13 Oct 2025 12:59:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvpCF44kQW5Htm2GFpYxYfXyTl5+0TLHHcYsSHm1UZ8A4aEwGaAWQh2xxcjFLKzYXV6CxPHw==
X-Received: by 2002:a05:6000:25c3:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4266e8dabeamr14498742f8f.42.1760385541739;
        Mon, 13 Oct 2025 12:59:01 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57ccb1sm19843079f8f.8.2025.10.13.12.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 12:59:01 -0700 (PDT)
Message-ID: <26a8f0aa-8d67-47ba-841c-2daf7010a2aa@redhat.com>
Date: Mon, 13 Oct 2025 21:58:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
To: craftfever@murena.io
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, regressions@lists.linux.dev, xu.xin16@zte.com.cn
References: <80b153cd-8bba-4bcd-9b56-3b2ad3f295e1@redhat.com>
 <46d26246-5bd5-43f7-b1a4-dc721f717413@airmail.cc>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <46d26246-5bd5-43f7-b1a4-dc721f717413@airmail.cc>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oZ2ULjOgs5FYfHqKo0-VESSnBit4O5fOi4cCEevML5U_1760385542
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hxrnrsisqxtcd6pnadfs4rpbq49kbw83
X-Rspamd-Queue-Id: 46BEAA0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760385545-153204
X-HE-Meta: U2FsdGVkX1/Q6DDnJhAmNJbqRoVntQxExXUQxgs0GsSwHdHRaJfEy2aYSZA0xdpbeiy2KBVso0t7J5CMBf+MPfp/ybgQOW0CpmMK61R2MCAQEcCCDfGHOM5JU55MKkPnmVCXHnUJd1fOnf7+0XjloWpbxGkYVXZK9fUiEnp0SX+g1aU8J3f6xoLI3vgF/uaZgmb6Qn18jY2R4kuph0F/hT04NTTRlWGwHhiDbBMuZtsAflTtySoco71+TF2uUKlpk9kVU8+aRKEpOXFHv+tq5//gda7MZYOWJxY54/GRnSi2670bmtJjiTXaTj2OfGhKheXZYIXRDgayKoe20RJrJw9FrAPI/lvnm83YjYaxXoDAoMvoWWG66mg+d5eEkTAc9Xbq3Hah7ihTUd6zT2ta1o+hGhRmfFStqUgnatkUALCuV2owhTb7Uz649X1z5iJUAnBT5DpzxhAYuyAT/y6AJANN6Fqpa+Gh1ppzFdACoQxc3lIWQsZr7Q8Wa/NlQEYrdvjtfpprB5du2rx8wR+gnYC2s6yjYGjSzTpPyBJUC/X/ndFETlWjEQ7bKDlwB7ltcXOm3N9gSRBuDV2q73hHkEo8sL6m+FAK7wu0ZnrujHCNQTM+Bpi0wTXJGzN6QmPK/JnCKZBlIMgCNpSZXgbJFIMI1cFdYzdKUIvmy6iLqdt0nkZZAAg4gdLJlgLLOBLgoYcLrtlTpFw97xnYXJmAm/wcC1d91VsZylp9uFdCpO60i4dgePTLcWz8H8sYCnOMO+XltCojv89BW6Onk1bHVi658bUEtAucdr3ey7rpoCh2HYxTJw1+BJVI3RgrHjY0xf50Rd1WWkhRYXpN4b4kpn1H3+ZRBlXpa645WR+loF7+ImKcWb3TiqoCTUubVU8yx6vInE+2ZO+x6VRqpUX44/pKbS5HN3Ppt0b8OhmUvFXzdaFJgEija1EyKXjoghvqhoGXH5qv9rruMuTVAxI
 S1Qal8K1
 TI9cU9qIBZSAPt1WPwZOEw3m5P1W19Zd/IlHlqx9EWMNcyWgp4/LUUk7mJDHhnTVDkupudiYSXSA4RQFo0g5C9DBjv322hcLjiRBBBxfKWnp7hOw1am/x69cCAb6L8hBBp0/ePwpzwhhsElVOY36VS5XFp0FsqwDBYT2elUz/IfLUNnqPoPZMDPIz4+9kKr9YCtPeNfJRnLJlFuRcIIpPVoB54eEW2UmXZTlQSt2cLaswFd32vs9rPuBXn87kG3Rxa7FNoNRXf5e6Q5uDK0ZnaSHgLqTJotSsuO4vZh6xeFk/ZB3T/AdS86NF68YvoW/6M3tNLLJx5dEN+8t78/hKSADJEPMyRReZPjFzQ688GdTkUJ1ctMGLR9sxiAQYQeNjVaazS3D2Lkdk/E6QWsT8zUAimBqDyXErMnCSEd+H74cKVw8aCQuDSKkTem4S5AQJ7YoLjRRUD/dh6z64qgcObWfcUBekjG9G71+nYMY5w14mx/ZZxmgPau26ABN7+/XQIgT9R7P01Js3IMAdECYxiNaFbkf+wQyw5jws4gRA0ZeTGZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 21:54, craftfever wrote:
> 
> Unfortunately, yes I can reproduce it. And I thought that lockups does
> not happen anymore, but I was wrong, I booted today with 6.17.2 updated
> and KSM enabled and whole situation is back. But, it only happens, when
> scanning pages corresponding to a process with huge VM size, like
> Chromium with 1TB of virtual memory. The rest is alright. It's look
> like, that the folio_walk_start called with much higher frequency, than
> in 6.12-6.15 versions. in that version page scanning of huge VM size
> processes is pretty fast and flawless) Right now, when Chromium is
> running, I expecting constant 42% folio_walk_start and 15%
> ksm_scan_thread on 6.17.2 kernel (contrary to 1% folio_walk_start and
> even less ksm_scan_thread in 6.12-6.15). I must admin that whole system
> is not freezing, just Chromium with high CPU usage from ksmd and kernel.

What about 6.16?

-- 
Cheers

David / dhildenb


