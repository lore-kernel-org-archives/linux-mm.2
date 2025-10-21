Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA873CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E298E001A; Tue, 21 Oct 2025 05:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F248E0002; Tue, 21 Oct 2025 05:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF2D8E001A; Tue, 21 Oct 2025 05:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 132638E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:38:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B51AB1A042E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:38:06 +0000 (UTC)
X-FDA: 84021620172.01.6789551
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E90A160008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:38:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jSrjCmp6;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q29DhQwTAK6dd4ZAsLxjzERt3jbFaX1obxxBjr33yAU=;
	b=tJX/O+N50+zAmKDWu8swKx5IYC4SpkNXMDi4FSiC8gEvH/0kEuqlQ8tTMtcVlU8Tlvxbup
	DPbGoK84dEZkMntw8Qh0X+S7RXqOjIkMYjiIay58yF+eeolJ2pB+huACuBSu+XPNeBqzjp
	gv3Kg4G3Cja/PDSsdwcuPkygTab6fx0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jSrjCmp6;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039484; a=rsa-sha256;
	cv=none;
	b=ZH/1Lit/DbllNS6LhDofsaKzYw+zxtkV+JRSHvNey+XdzySsLTesdceBSiChMAGxLo6kXL
	Piw5ENb1kBYIa/gn1JrNG57ZzyX5B2g71bzBNyOVCDJ6N2ud3MU12/yBFsWipgeinDvgTJ
	ljgqYdEHcU2OKAYa/AyJyfzjfO8Xc9s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q29DhQwTAK6dd4ZAsLxjzERt3jbFaX1obxxBjr33yAU=;
	b=jSrjCmp66Rt/Zd6RcY7cr660wKbHeW293RBAnksNP7JEpU1hAHx5nPn9soPAC2HdULNjZK
	fRCP5hNPq1x+50NOK8Hs8NvELcwNKAMRci391TTQEq3fKZDyvMxcE7vsLGyK5KGT+Qqzhu
	r3/bAnAvGrikxGU+xS2dwCvqFTL/PE0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-BUUwhXYvMUWPWo4DA60IHQ-1; Tue, 21 Oct 2025 05:38:02 -0400
X-MC-Unique: BUUwhXYvMUWPWo4DA60IHQ-1
X-Mimecast-MFC-AGG-ID: BUUwhXYvMUWPWo4DA60IHQ_1761039479
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so6198980f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039479; x=1761644279;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q29DhQwTAK6dd4ZAsLxjzERt3jbFaX1obxxBjr33yAU=;
        b=i28hiw5fCSB3pjuzquNFjNRx321/8S0GUBYaWEB6QJE3GqDqQCwhcSI/IfYy6Saa0z
         Z6w3X9MlzvMXyzRq6VJk35lF6MzYDNrKT4wN8XHPbAg0exlIjbj/WSM48+CNP85jDexw
         P/KkyzqlAIBYjNU5YJiajSz0euPJV3GfskNlc5UmFA1BoV/sABfrnLSSSNwhnBFFYMEV
         9pQ0xen42p61yBe8a6fsV+euw8reTNrwlBpoV3aRYKswUPNvqLTPyW39KrR1QYaHByjt
         /8WMcR8Of1glpCAD1GD832VOmKgpfaSK9qXdfURZ2m166aVy8FD+J3iIRSe40iLIYxqf
         so/g==
X-Forwarded-Encrypted: i=1; AJvYcCUafbYCMTnmBegv7L3UX1YEz0FLdQpI/0+IPGED5TzUdyXUNlTi5fnWoSFfFWa+MRE0NoYK20VcAA==@kvack.org
X-Gm-Message-State: AOJu0YzVv6sAU5j9YG2QlkP0EwIdl26OTtWeb0PdleIFhyciQiJXpu0Q
	0vPTRSppNaw7n3djJlcpG1qKLoG6OsJLLLSnSwUppngpxMrXpO88FDb0cyF+wjU2aIjiWQikDKl
	ULEg8P3+fhYjAI9ASf4Pr52W9r4L4KHOeIQsvNJYlopU4nmAYy+3A
X-Gm-Gg: ASbGncuKZdUh8w3TznskWk76nWfW0Khh2UgRVQ6xN99qlD5hgsmrvcDVC1wz/08lfvJ
	dDIzyb6Xq1XI9yJj+Jf0K/LOW8GY1nQj8cR9djr3gY7B4IjDF1fnD3dn+UO7rUq2nw8EvFCi/W9
	RCq+hsKM+Uz1boMbl2hvRRBbH1scNiRpI7qbRv4VBezZrc0tXftSb8paXvmWlIR/6VbeIX80PU7
	TyAwdYV3Cfh/zjeZeHR0CfdDnHRuNk6PUu7uA596c9vC73tS7Y5sird3f/ddqq5ZgYKwIHLMRlB
	3P6JzFPH4EeVQxSTBld7C9aTWksSqE/C5hQy3qKLQYxlOgOi5jhM1x1IGAT2+myCDzZ3a8NTngQ
	YRMddfuRBQp8/txqIDs4/DLTBccOhA6yiH/N4waqnemuTw/lydzfHwreL8vauCmMu0xl/dQ/vsA
	vnKTvDNKrKzoOEDE78qMrz8WLVZEo=
X-Received: by 2002:a5d:64c4:0:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-42704d442f9mr12220838f8f.5.1761039479074;
        Tue, 21 Oct 2025 02:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKruvi/TAKluPv6cz2boZrb3dbhZ+r79GGju1INC+ReltJyDrEtS+cBV3xo2qL/hT92CNu2g==
X-Received: by 2002:a5d:64c4:0:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-42704d442f9mr12220818f8f.5.1761039478657;
        Tue, 21 Oct 2025 02:37:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f19sm19610031f8f.9.2025.10.21.02.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:37:58 -0700 (PDT)
Message-ID: <750cfcac-e048-4fee-bba9-6e84edb7bbe0@redhat.com>
Date: Tue, 21 Oct 2025 11:37:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: enhxxV243-eyYWCdjSZCVS9inwttiJzvLGjhcsnHBcQ_1761039479
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x3cfkffbjtdw6scqbyop7ra5z6sxg4gt
X-Rspamd-Queue-Id: 3E90A160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761039484-335849
X-HE-Meta: U2FsdGVkX1++X5WRigmTXCJ3ZiZliv2wv353N9D/VDU9YRk/WyvlGpurNqdwk+8PhET2l2lHs70A3NpIG3udiRnxEWuMgaywa43YPfLWspdiJ7U/Hz3PzwpHKkyPsDBa90EMXFriJ3uomtoUSJK0LyqZr4U1gL12kgxga1CATc+vZgZglmOde9F7BInaRYbecM5o3tlR1CK9KAfsEouEKTlLD71mH9Yx/QX88d0llhgSDAfmvQ+M6DC48FSPBstHTqCzrXhAYKmWtC0YduCGxUxZ1nzZnm4JZ9JKI6NFjoNpdy9mg96AHf/GAKi3VNyRh/dPkzF0NNXnfR0ZokXtZ91ewIXbnsGLT/jgfAgiC1W3Lz2MJOV22uxtFvQ/0+w4JVCA4nhFDA1oapUOMci6FONRX8i98kJckZTTzpI5lcF1+Sn577F6BIP47azAJYsPFc4PyZSZVgJz9Nrh1pTLu6R4mUDL6BTZSEr0CBxRDCH4KIuVMZxk9ogch4x04GR+ym0infPc4ixfmiQl80XkU69gbzP2wnBBuHS5JMgk735HxckWi55zNOWvxRZqaytiEpsWpn11JEUPhDnYIvDbKJDmrFtbtIllaraVolAMFXmuknQF93a44ynW6i+LHXrk/WGg0AoBbn0zLuEhCOox+MMg74+oF2uPJSwHZnyVQeVThFpbNyJc+OO92TlMYuG2tb1leJTaW1HEElJVzFCeCdryMYfDX8OU0h7PJFbpDCZoab2ZcBQZ2ryYrvXgSPdDGinZebUf8TWYZmn4VxTZh27naF5frwKqYSpRf3UoqQeyUN3H1lMPisHSQAQrxrIMrQyjXnZJeTZjuLa4kMzoEhch42zeEilSP52oxHrBieqqlBzjNBt/rmF7deYihAmX5XqA4t33cMBMBHr9bahd9Mh8M/ie2ZfMiq2qLtJjD/c2MMY+7sMSfyNLH4wgOgx1sDY3tYnJpJue08jV+4C
 JmsPwxTH
 S4D4eBE0RMZmZAq4zD1xI9g+r0jMBsfEmrFOcmX6v3f5+Gfedvn43S/hh1X6QVey0IMF3eX81hE1e5tvPh1a+FDLwS044UBFnWkKykaibWUOp00fEn51FIlU/qfYUptGwrLLX84NM6ldce4fRyEjSR4A3VzY/pbRF7oFhNrVD2kEIUfQfzQlywzPZDoIQvBIM3Ct/eZ0cosHVmC8OhqZmSgSU2/b4hsBFl5i6Phr28rgHu9tH3mYteHU/iVz281tG1t5PZMmX6P8dni6WYK405IHD+mwt5J61so+JBSBYeglBX6SF88YqrSiAzo5oWvdD8iGntqOBm7QvH1xGzeRyA0VKHYKTI18UrbAzI9ieQaZYFCExyybHKpIRVBsmrzMVWJqbIO0O+qj50nGeR3uSVlbRAbJfoK+i4ypa2iyCMDs1wlM+GNDgMseoe4XLTY6zWfPB2v7YQHuqWxuxtObKCifCEzvjyPfxDxN4di6AVjVx9nJf6DiyN6alNr9DnhBZp47xw9JFEHfF0GonTRBwNMjeChBqUPPvdZR5a8mRUr3SoJvT7kxNCg0I3KrB66/sfZeBcUdhHwiyK8kdSq9MzX7nD0cb3NiSQ00m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 11:22, Jan Kara wrote:
> On Tue 21-10-25 00:49:49, Christoph Hellwig wrote:
>> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
>>> Just FYI, because it might be interesting in this context.
>>>
>>> For anonymous memory we have this working by only writing the folio out if
>>> it is completely unmapped and there are no unexpected folio references/pins
>>> (see pageout()), and only allowing to write to such a folio ("reuse") if
>>> SWP_STABLE_WRITES is not set (see do_swap_page()).
>>>
>>> So once we start writeback the folio has no writable page table mappings
>>> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
>>> just fallback to creating a page copy without causing trouble with GUP pins.
>>
>> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
>> mappings.  Mapping the right answer is to just fail pinning them and fall
>> back to (dontcache) buffered I/O.
> 
> I agree file mappings are more painful but we can also have interesting
> cases with anon pages:
> 
> P - anon page
> 
> Thread 1				Thread 2
> setup DIO read to P			setup DIO write from P

Ah, I was talking about the interaction between GUP and having 
BLK_FEAT_STABLE_WRITES set on the swap backend.

I guess what you mean here is: GUP from/to anon pages to/from a device 
that has BLK_FEAT_STABLE_WRITES?

So while we are writing to the device using the anon page as a source, 
the anon page will get modified.

I did not expect that to trigger checksum failures, but I can see the 
problem now.

-- 
Cheers

David / dhildenb


