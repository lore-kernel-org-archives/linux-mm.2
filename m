Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD19CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C048E000A; Wed, 10 Sep 2025 02:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603898E0001; Wed, 10 Sep 2025 02:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2B98E000A; Wed, 10 Sep 2025 02:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAF48E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:35:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF1BBC07BC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:35:29 +0000 (UTC)
X-FDA: 83872379178.30.A57EFBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9C8F100003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:35:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gq3Websf;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757486127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/tuWACW+YE3IQwtK7wyAuuhZean9mhQqCKf9VrtU6k=;
	b=i/cMQtcgCnjNi+FIcSDT0wQg/h9F7UaS0TAuI28KufDvVTOku6Mdu7PTB2zjrfd74Zu/1S
	7KAszVA3LC26Rf2GJ7nCxJBN2D1S2w8kcjpMv+371fHVdJyMUBG8PN7ajYGaDiWB7UwL2S
	s5vJIQFCseEFHjj65lKjWb9/O09lmqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757486127; a=rsa-sha256;
	cv=none;
	b=k6Upk4z5F3x3N+IEkm58MINcfRQYr6H0YtWFiPDjuaV9Im2UdPo+alSZgT5E+nUJWMSa4D
	c+rkf77ytiSzNcGps2bcQMzW99xBD+MebDB+tVtraO9ZDY1OiyI0d/CoxoRVfaTE5soKUo
	D4UnWj7Do5+Wei356XhHheRJjFuKqCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gq3Websf;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757486127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1/tuWACW+YE3IQwtK7wyAuuhZean9mhQqCKf9VrtU6k=;
	b=gq3WebsfWBcuOA1kHiaGIppdVhz+Dezx6OK5cQFhuWUNeJ2MVZey1lK4th7UWHPfTJNvn1
	+kCNhhwJlG8N3KVunnj2ajbClB3z7lJxByDl2sFKPLEsjhrSrVfNrXBmp5ELqyfOkBNyQB
	8UuvBUGeEgieE1VBs5M/f3agq1aQ/vQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-UvJiHZ6MOU6hOKM8R8YlDA-1; Wed, 10 Sep 2025 02:35:23 -0400
X-MC-Unique: UvJiHZ6MOU6hOKM8R8YlDA-1
X-Mimecast-MFC-AGG-ID: UvJiHZ6MOU6hOKM8R8YlDA_1757486122
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45decfa5b26so9053395e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 23:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757486122; x=1758090922;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/tuWACW+YE3IQwtK7wyAuuhZean9mhQqCKf9VrtU6k=;
        b=Far23GLzJUt325ht/DyC+q6GMh8yjVzRx+zYPKtH5sG0ZzpmFoxrtyXjpJZqkFiP/J
         h9gj2rKn+yNwF5gM4okQgCygIero36CQvXO/ZLvKjq5vDV54ukuNrIwi14jlZeXV3UyV
         OPL8otNEeoUpWiLUdUqHJFr9/lO16/WiQ5zm0KYSBAU/ZHxvEwcn8KezCxADrtuNtqCb
         rL7JhNQuRMY8Zh4uxJ82zsTiZqV/YyzyziqNB1B+7NshK1rSueuBk8zSLgSTAHL3Zugh
         kSMCRFkh9Ndp9fZEoY14L/e44xfw44jQKeJahJYWgRe0o769aA9Y0fMViXAc+oNRFvjo
         c2UA==
X-Forwarded-Encrypted: i=1; AJvYcCW38pa79ACprqTC0MR5CrSkyIEqvj7/XFFH3/GR6kSSkWKUQRCM2bqCyLjV9658OqXoEdxkCLFo0A==@kvack.org
X-Gm-Message-State: AOJu0Yw6iRpBHk5Vqlj3JjFw9ZU2UfTLto30ZiFZT9XTbAFVkhnOeZRr
	LNOliBN+GvobT/vMf0eRK6CaB7YGh5dasibhI+giPW9duEXZ8RZCTqCG37I8GT/AXfVCKvqO8LF
	aDeDeL/VZL1QD0cjJwXVS2vefC64JVFhCEK8q/LppCwXy3EZrkZ89
X-Gm-Gg: ASbGncsXV5cSA0aI6lUmboaUvJp4tUDah+1MutTpvTBGkQG7ET9oBaTjlgPP2v6NShm
	09l1IXtfujBKEbk2qJYy3EGeVpy9w8cYgXHagSc22B0Ps8DAyhr/HI5/3M6io6TXBE01YLsMsWU
	eE1kCnzAnDjV1U4GjFuqqBKzAiX8fO65hOrqiMtUzBpUwjT/FJMpji+1IDsMN1cCr+MgnGhoFbP
	y3prBEKKa60T+QsSj01gsz7ka1+kfjP1+K9X80fDAWMX1LRnDwU7FMLhMCRuSNe9AZgedpkXI7Z
	GTIm6/iLKjlgbRru/2RD2kAsPJtsX8ZQh7jxGgh/1nADEMWIioUJKsdzH8nuJfZvhfLRfeGW3RB
	iIU0rSXrXsIF9ZD2BleAvpwqy0FFufjWNSYVCdV+2fUqG1GbQARIn8lAMU+5U52odp5Q=
X-Received: by 2002:a05:6000:420f:b0:3de:8806:ed17 with SMTP id ffacd0b85a97d-3e64211e36bmr15711707f8f.25.1757486121992;
        Tue, 09 Sep 2025 23:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1CLbthnqMg0JojmsnCmMzIo0FEhwz8DHkvvjIQ85wqRnbvrk5Vvm6brGu3SKd0Vt6WZPpqQ==
X-Received: by 2002:a05:6000:420f:b0:3de:8806:ed17 with SMTP id ffacd0b85a97d-3e64211e36bmr15711680f8f.25.1757486121523;
        Tue, 09 Sep 2025 23:35:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfd08sm5429110f8f.4.2025.09.09.23.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 23:35:20 -0700 (PDT)
Message-ID: <26a9495a-cee7-4db8-895c-aeb0f1784989@redhat.com>
Date: Wed, 10 Sep 2025 08:35:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [crypto?] KASAN: wild-memory-access Read in
 crypto_nhpoly1305_update_helper
To: syzbot <syzbot+634e67b3f57206befe3c@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au,
 jgg@ziepe.ca, jhubbard@nvidia.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <68c0f496.050a0220.3c6139.0017.GAE@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <68c0f496.050a0220.3c6139.0017.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: XWQZZK1RcUkXUeC6Wm0wxUo-1NuAay5y4Nr13OSNnDU_1757486122
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wqeityo8n8mqxx6ammbuugruaqgdcpex
X-Rspamd-Queue-Id: A9C8F100003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757486127-289826
X-HE-Meta: U2FsdGVkX1+LgcyjmGh/BIXmtjicfHez50CVrQWu7TQ61Z/R+soEYDWCCxqZFDe8JfPtwZLYhG6SB+llaZIPyC8tOUK2kQsZ/k802ZqyMFs2wMKHmsDEQA/zc7hxZMDKGb/KB7d6QNZqVcJYh40JYAnClDqo6ozhTiz8qy3YOEdOtuYy17M4WzijNPdLanadRYUO/NwK0Xg+iJPpTrd9xKWEFaTF5N6pbL8I5iwGPXJdPClVr8nBMf1vns7qmTxHmh0Rr7bcNPcJuhdd7tYjQ+22sZzcmF9k22J3i1G8uJiP7HBmM5z8dfDN3JJQsMZlqQsT1uvHH+AHh1xjF021IjTrkr6QdBN9iGH7kVVKXAZn8vACBfeT5+uS0fZDVv7Yl1pXbvYxxLPAoM7HybJuKfJQ/dfj/8nxotOIcvZrMEtsvdscweKwp/AR4syqVb3wqtVssPzFrQCl8AfRzp1/9N9tFCFSi4Pqrwy0dKrrN0qUIDzL4jk38Gnq9qa4iGyqyKlaDHgKlyslzkn9x6gMpqW4tRCnIU/pg26X1TrtpXqc4ByFU2pNhrVKd33fsfjYo180Vgb7GEkFMjNecS/Edel21D3pOsXpkuPWfw+lTOOKyEctPxAIQLxyXbdfefqpjWspfuQqDJPSVY2g8TzBtO5M6wNcrjLKOC8s1fhQBm+Uf8pIVFi7FiDE3eRBO9xR5ryNNaMS79D/EkeCoaqCBH1Quxz+BISoSXBnLZDzFme66AfZij876hGfY7L8PA5hgJ880e6r8DNpMxe9w/7ybb03ygrkMbb/SBCqfOnYlc12Wa8Th8KgUl+WafZ7ABUe8hi+YVT4Bv4K8lJdv0JmEn/Cez0n2nNLVMuX9NZomVF47jwxtmayypOhhmdSBm3/nHgdNOzmRPa6QDn3EHeNhO+eWK8QFaXB4RkUWWJYS1uEMYJlkUaKvnEsn1bXdQc2bDgPPCytX+Tpuy/M/SM
 xj780tEH
 TqWAZUbcnuhxtt57fO8sRANvXu5OLE97MRVtoh7dJt3iaxmEzq/JvrHezctrWqGuYP7ktj+B/TJR0jN0HJJPMSIsFSN18F7WHQdL3/0i6Ed/YJgdEFmQgZU8VTuXo75egC2Zdj3enlAVc3vL1jAjSLRVqU+BzjEfMgdY7CX+mWhIs2M/fGtyJqErRMuaKvWdl+MF87pVfIORs1m5OUT7eYfAfU/pm31qCOLu6q23KLtDii0UlaM2PqLRexdWZbig37KMpISQVIgxVDK+R8BD68uJH9zjvQchxoWvOGZ/9YstLB8WGQijFUvS5fG4Twxgk5giWbTePskoUG3RQkYUfQbd78A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 05:46, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    be5d4872e528 Add linux-next specific files for 20250905

^ old tag

> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10f70962580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
> dashboard link: https://syzkaller.appspot.com/bug?extid=634e67b3f57206befe3c
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1247a962580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12751134580000
> 

#syz dup: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register


-- 
Cheers

David / dhildenb


