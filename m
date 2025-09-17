Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDF4CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D4C8E000C; Wed, 17 Sep 2025 06:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEF18E0001; Wed, 17 Sep 2025 06:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C69F8E000C; Wed, 17 Sep 2025 06:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5778E8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:32:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0245513B259
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:32:32 +0000 (UTC)
X-FDA: 83898378186.08.32E3AF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8FE62160004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:32:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJXyP10i;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlRZ+feMVJI9HrMKZRZihA3w6aJ6vv6AK7D0hZyyfXU=;
	b=q/y0Rc+3NLvwVpy+DqUTbRcUHoEF1JYHK5uWSjuCi9/CfCLnPQ/oK+IVgAAbi/oj+3J7so
	h3O4pliontrxdKKOOnnkFE2m37rddgZUeG3X0sPjGxvKngmTzHr9ty5cacrAK5li7H+Z1G
	4seCWBiufZCtqONdgFwE+y9uO3yCqKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105150; a=rsa-sha256;
	cv=none;
	b=eJBvL6oc88D+LHVV9jY7xU5UG8F7whBtMfA1wv5e8/ejgfTvB552pL+4lqYtIsc0oUcE0b
	o1Eh4fsJIIPsrpGSD7PwUqtCxU5cwNxJFEf1/3SAENXqGV7WuY0Ir7TYq62gYEanTTrEWU
	mURZnZVHcowMbAk0YXcifJJ8jCD4NHk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJXyP10i;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758105149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BlRZ+feMVJI9HrMKZRZihA3w6aJ6vv6AK7D0hZyyfXU=;
	b=XJXyP10iZC/rkKeN7vv9qQMZQRY9Pw9L4aK6XU3ZDCo1euxv/3cGqs6Fs6/M0WDE21gVSu
	vj9zNz1q1vJ07VXPLTBU/R/vWOGt6W7ersekrsWWvy2GfGuOviBQmLlLsAjAI6BzuBeiW2
	BySxpyGKndBBJd0F7+/0qWHg2to1nUA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-m4F-AS5INfKGdGQi13-EAA-1; Wed, 17 Sep 2025 06:32:27 -0400
X-MC-Unique: m4F-AS5INfKGdGQi13-EAA-1
X-Mimecast-MFC-AGG-ID: m4F-AS5INfKGdGQi13-EAA_1758105145
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2c41c819so23108325e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758105145; x=1758709945;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BlRZ+feMVJI9HrMKZRZihA3w6aJ6vv6AK7D0hZyyfXU=;
        b=iSHqBXnr0XUEZYifVfJacTqB+EJldb0RCRcQwqual16Bud6JN+qT7XbHH2G4K42Lo3
         uOpeXbmRdm4WPaa65AnvMKIb3P94MhYAnHB1P+zZ1rwfd3pKhyvBCsLT50XLSnGZjKxk
         R+rVb6s+aRscUJL3ndWH7UKGsM20qBH4qaH4xAMbJc/+qp5kTeKqSKIRI+sullBB2geq
         YLCwjV/LoaaJ+/Mpsem+IRrAffBqvi+94OQxeG9QtLHEc4NRt643lyy5oOc/Pu2IJIkX
         gHzx/kOFnY+28ucyw9recba4Ou9972fj/rvhIMohes3Yds0lSC7lMwA0ljRf2hnwJi+/
         oCow==
X-Forwarded-Encrypted: i=1; AJvYcCWoSXqGho1zP59mA3Ik9wHyd25DuSJ+vquj8oWUqoMiMqdtbV4FmS8LszI6cWuSGnrOw2eauhi7+g==@kvack.org
X-Gm-Message-State: AOJu0YxZDZXemr5fsTrPX6B9HI3xUIoa4cBR46aWZl6NzWkrE23zqcO1
	fBjBlLgHU3lMOmdeGbdrBGK9rpzoN928pkye2jIlmKiBlDNQaC8EVUrxgl+soJmgshyV73+q097
	op6j6tO5WK9+aVEIVx8mSuAGg3dxPtLs8DsHJeTnIW0Z4qS29M7W0
X-Gm-Gg: ASbGncufiyJPn83Qa78/wF9TLPQC9WI9gjxGS7WYSP88YqCkr116LmYbdHQI2tkl9uk
	6Goyk2h3IAKc1lUkl/AEMt83q+Y0eMGIBQtSWkJTx9Rh/A5ElqKvN80+u3V/sogWj84uEBeSIhm
	sLeD9lG2p4r5pqV4N/zHjRPVURJzqbmAShyB3uufoI91pbrbU7B1B+rh+1HzcUfqNX2EeL7SE6t
	bjQCDvFrrhgFCKJOpdSPt7lbXxbRcmZE5hk/F1S25oDIz7hXaUgqlspd4lrMphzaPZaggXKFMzY
	H72HOvPXGZMHVsLrWAYOUvx2X4mWPokT4zRDqSgf/tRz7ePkpK7UpQ+7yJMojj7KMZ/eVQXlHai
	f8CZC08gQ5YrD1KVsI4yg3eb0ZeqjVyYQr/FijqnNIph5dGzAQmLJDmnLio3tqgC4
X-Received: by 2002:a05:600c:350d:b0:45d:d2cd:de36 with SMTP id 5b1f17b1804b1-46202a0e76emr13132425e9.12.1758105144865;
        Wed, 17 Sep 2025 03:32:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpso+eMJMa9j+B9L21VGPP9MNwi9qIP4ozFnYckAdJluKclxzsmvXDG22KG/4dHXM6tBuXAg==
X-Received: by 2002:a05:600c:350d:b0:45d:d2cd:de36 with SMTP id 5b1f17b1804b1-46202a0e76emr13132085e9.12.1758105144387;
        Wed, 17 Sep 2025 03:32:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f3211e8c7sm36470345e9.3.2025.09.17.03.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:32:23 -0700 (PDT)
Message-ID: <ee7e0841-e9b6-4a91-8b6c-43252432516c@redhat.com>
Date: Wed, 17 Sep 2025 12:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Kairui Song <kasong@tencent.com>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-3-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250914143547.27687-3-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bB5dOR31R7EGoeBW_wWI13M3LBprh6Aq4y4QLK6qSqk_1758105145
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8FE62160004
X-Stat-Signature: 3fuqrdo4a1rtmtprwo5946ga3dutuzid
X-Rspam-User: 
X-HE-Tag: 1758105150-58747
X-HE-Meta: U2FsdGVkX19SSjdI2R39PWHgU3MgltEXaR8/PhOTQPHtOJzcE1SyADa//PGE5BCXCpBKw7kJowFXdKjncf9AkoQjQlFawzHkFwZ4jMrvjOhdRA3PYo65KbOZNCLlt10MzQKezUN3OqhcliCbJFSe1KhfJe1u9+Iayfe5pE0vbIe+sU/UW/z4fCIfBz5ST4jFFds6nu/89UT3Sx3lTliqgdK29y4Lm7QRtM9QUGsY1YOEYVw063YsJEyy2Nw14PCMGikTHgSPlJckYB2jcNSoNHv6OgmoLOOiSVBCn4GVqcRtYyonyhQ8odhXyDpQ9g1UA5yb1Yu95KipL2bPABA5C07U2wfVV/xYgLAdWrWVYB2Ux3cU2DDz4CR7o/R7ao7wcuByxDBqRJpAvOXom5UBqVvguMEnzhsHiyK7JrArUwcRIPTSwFRri5/5krhCW01JbyCZqH7VJtkzTix1A9m2PD1k2f/kF1iHN/p4a9qZxFnjVJncroMaXbUSkmuuUoWuBiJ1C0ittfU9+CUHq43lGtgG/bzyq4RrSeEed9L8oU87eQ97eVgxbZRQgswwuBVSeFeXVF0PjnFMY//89zP2nkeolqpE2MEOeyk4zJcMQ1yAW80fI9P31VG/SPzCEgjjEGgh0Y0WeXEJJPoMbx0eJbDcIhaj3OxSuLUIg5EGC0z0sXNgvfvsnCT7hFkCpOu394FKoE+BLFrjJQlt9waz7SSjlzgmtzrGK5dZh+QHhrdu6fEJeDcmvma7igydUHEu7p/l/0bOdolDK30tWDqip28aJo4JZ9KxD4fge982gh/BqnuzzGIK/uPQ3+Rm/wpZGBdb0dpvSzmbb7inwVDwusIuuM9qa03rS6gGcVZjULrFJl+vAcjaW+g1djSRMsHwv6oYecIvgIeelmG8Tlu9Jrdi5izgUuTfw7U8+n8bFbAg5nYDT7d1Ldx5BtZ23BPTqKYpKmgfAmbdPnRf3JI
 6Bhmm2Za
 Tr3DUF46r8XTNCBQBIYmtC7U5dWSVJDVyqVIp/DtJiE09CjVME7Fs3d9tiZCB3HsIgW4cH2ue+mbE2hSXeRbfQFwOTskq8WFN8gJsu8gHnS+6z62ZLA6C0ZEblX3mcjGq/4dspGDwz5h0agDSCoX0q+aIIkR0uZlmCW83kGdrXXm3ZMiwtkiRjklmF2pM6UuZcjXcMCf/+cINxOeyFqq6lHy32ELipsEVCJM6XuVXOdH0WFEpDc79sGpC7KrWca+4R73VaeYpkN3tcTI0I5xtJdP2rEeFtWMhUTG2nPhWdfnBScfLkIQKUDZ1Z6C6/vm3ADwNcYdK9IljpV8YS37e4V4bVIgLgmb3lBzL/4V24Z2XtfzPEMW5eaFjDg6A9a/1SbBipIjiWXU8g85XCBgwCb+BX1o10QQ0Oll8eD6z1dT/UCEelOa+/h4SICa9AqqkcWYlwb5F+/GAzNVpdYfUdwAT6fNgfqmo9wCwMhSCm8sGpV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.09.25 16:35, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> is_guard_pte_marker() performs a redundant check because it calls both
> is_pte_marker() and is_guard_swp_entry(), both of which internally check
> for a PTE marker.
> 
> is_guard_pte_marker()
>   |- is_pte_marker()
>   |   `- is_pte_marker_entry()  // First check
>   `- is_guard_swp_entry()
>       `- is_pte_marker_entry()  // Second, redundant check
> 
> While a modern compiler could likely optimize this away, let's have clean
> code and not rely on it ;)
> 
> Also, make it available for hugepage collapsing code.
> 
> Cc: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


