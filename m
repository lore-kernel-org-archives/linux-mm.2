Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7F7CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B32E8E0005; Wed, 22 Oct 2025 04:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B058E0002; Wed, 22 Oct 2025 04:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A718E0005; Wed, 22 Oct 2025 04:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5596E8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:43:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA0A71192A8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:43:53 +0000 (UTC)
X-FDA: 84025112346.20.A2B746A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4EB7E40002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:43:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H/niiM1Z";
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761122631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkHMky5mCobEjmAGe9TQAKstGmetuf8oWgBGBX4vP2s=;
	b=KyvGTrDQWJcUaONrGaK2ek679M3H9khEJn3e/FHqc6xnOeauuxPhbI4mmPlRlC1K6jU6Jg
	uHy2kgt3B6d5zlxXTXPvuJ4YLUGJ1SotQl2bVJd30z2DzaZtljh53LwcXEEGebqh1sH8tL
	52ScPZQkQE8Cb267LLNvJi2dylaBlqE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H/niiM1Z";
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761122631; a=rsa-sha256;
	cv=none;
	b=4+Fg7JhNSeN3keiiWaj4sGUZcfxUkmd9dnDVdKutbswnbQgmm9RAqgL1xFqTxMF7NS101s
	NXJNvqwq00P0Kcn+4VQAojSFl/a+n6J4JwHiyJMjU2SWZBP7kkzvzEOI/ATbgUGVX0LWrv
	Ebh/n5vc6ffRFyCCD5FCbuMd7DT2xw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761122630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jkHMky5mCobEjmAGe9TQAKstGmetuf8oWgBGBX4vP2s=;
	b=H/niiM1ZYtr2S+9WmRrcF46HDQfkHsy8/yrHnRJv/2TKhLJ0X8uI3YID9tQbee74pY+9wN
	URlvDypR2oHnCN1PLorZ25wzjXtDGftplHM1p1A9LhxIxQC96hCbsxSE1yEIFGoPn0Ip+T
	1Pf23WJgjsNffshc7ARHgghWNcHJCmU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-RzfXAa5iMvmxwjvJo-OK1A-1; Wed, 22 Oct 2025 04:43:49 -0400
X-MC-Unique: RzfXAa5iMvmxwjvJo-OK1A-1
X-Mimecast-MFC-AGG-ID: RzfXAa5iMvmxwjvJo-OK1A_1761122628
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-428567f67c5so110564f8f.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761122628; x=1761727428;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jkHMky5mCobEjmAGe9TQAKstGmetuf8oWgBGBX4vP2s=;
        b=huhZiiRUCl85Lrce9NXZXb2WM2KM2yomB1+EOveGnYeVydWFYevQbJX4uOhWrf6Yq4
         oRSeLoIiCTXSfzFd3E1Zeo0N8LbHGtfb5vmaYx/J9v95ACjLcEEh9DB8boC+CuPqXSU7
         adF5DaD5t293qr5EgfOY1LDFeNImOG/NPJ75Ji0+sH5X1/PCxxybqKPXeGj4HdfjFFME
         Qf6WUPOWzXJgqwb3vyGqXwHmSmkFEPH3MuzxP64RU0OVE4J+nDaG/jv2xjjW8ILMEIwa
         DbXU9bwLqktDMaW922TLh+I+8JsrStIINum08QcuX9jWdI/lv42OP7/28ctcRQ/2iobQ
         wRAg==
X-Forwarded-Encrypted: i=1; AJvYcCWAwz9s2JEhxS1qK8NitX/9qGTc649vKo9g6s9pvd2wmjII1XXNKoJofayhjWwu9AKwJzQa3Hka5w==@kvack.org
X-Gm-Message-State: AOJu0YyTlxxy+E3+Af4BI8maAXHQOaOyrIxUsBXN4knoRdQGwwuO3Vdc
	IQfVjFrVafoliY2WFuEhD2fXPFjxpv0JNRX94lW59a8Gh7Is77CsoJzUvyBSomIEN25Q60KWSNX
	8p7SyYbINPgRuKW1BhX/eV/HTxyJpbYeS8wz9p4pw8XTw2BalJE4G
X-Gm-Gg: ASbGncuagmchkG8S7TK8cMEqL/bmcxoh08MhImjY95ZYqFF3PquYhWtAHGegfWjvjj1
	sOZvAhsVVG615L1QC8UAZujowHxx8nCmqjp1QDTt63Tqm4XA5RVUlVWwXJEK+s5aXfi9ltPlhQl
	yWPwwN/h6HgOq3Srh9+DBE+cQLek15pfi0z+9fZhbRwokIjLVjtDQAlMsV5rWnVe3snrYPFxVFo
	5QlBTnBm1BW8mpjwSBtqZy88aZ+QUWUfs65D6agAH+yvf3MgnzPDSKmCEv8FOhA3iQ++bVBBFvN
	3LkIxOmGzAZneE9jgZKm8qR+Lp/2d67oGrRpX+qfa2Eva5LAL4O09dkZ0kOl8tD2dYla9/AP9V8
	rDHvVF16kphtiXfzW7ElLhvgHbLV4xalTJxIGRXqrs+9ka8T/u/pnc7dqH7iU8bh+zxKgYBGrJG
	2T7QsN5Z5CklP1yF7BFmcyokG7CfI=
X-Received: by 2002:a05:6000:25c5:b0:428:55c3:ced7 with SMTP id ffacd0b85a97d-42855c3d35amr870752f8f.28.1761122628110;
        Wed, 22 Oct 2025 01:43:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwoT3C4h+2nYRtAEAp4gukXLbzQesuywB6jEq9IZ/b7/4k/4nUiirxc9OucZncsYgrM1Y8ag==
X-Received: by 2002:a05:6000:25c5:b0:428:55c3:ced7 with SMTP id ffacd0b85a97d-42855c3d35amr870716f8f.28.1761122627657;
        Wed, 22 Oct 2025 01:43:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-428566a7906sm1313560f8f.38.2025.10.22.01.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:43:47 -0700 (PDT)
Message-ID: <4b280f08-7ed3-416e-8f8a-d30cf0b34c01@redhat.com>
Date: Wed, 22 Oct 2025 10:43:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/23] drivers/virtio/virtio_balloon: stop using
 balloon_page_push/pop()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-12-david@redhat.com>
 <20251021165854-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021165854-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dwQ4fJe6zu5EzcofUXUBH-X47LHh1zDWFDl_hdRn97A_1761122628
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4EB7E40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kbrx7bng6z9srs7xbpi6wt3gghq5j3ew
X-HE-Tag: 1761122631-257745
X-HE-Meta: U2FsdGVkX19SFjml8KVo3GtB3/Po9clzTE7bHN47KgLv2fI5PBtKwOQfLsdfocG8At6YKknBnwNlmLEpiQM90udvGeu4dbYGx97pVxewM750oUlNNoEOw60/ij+w6K5dJSj4ih34V+f4kVmPd30UCq80uM97A6RUWAwQun4b5FKu/+0HFQQecnOJoOopywSlWfHtR9vVbYbHQaWfavyEDbjBUoywn5wVEz3shM9gNUUM0QhwyTB9i9qNgsaEQqHfD+Le6ZoQzUZNqAnT/bqSuX+3jDYSJS1ee0LE7XrGcp8f1qDjLkx+rBW8O3Agt31ghSJCmIKzZDLbUdLBmadBHDC08vNs0YM775XzzhToTXbbBp+RfKTFEIsTozuY/v2V8Gd4pLssFBXwJy457CugdGkU0yDFtosaxNYK5C6KktQCwvInnz+Gddf3Xvf3WjcIMPRWPApk+odQQSfER4xP8pen8l0obUtEL2eTJWZKUJNhzHql8X6KONkiK2UN/StZb2k2fairsm+Ht6jtCSLbLZuwX4gQIE+UFV+i6qCmA6fCDCS/f4/eUsYME6s0bGgNuhUlXITeogcBEqmJd7/bXVJP9HoQ7DPlZdLx9AtFOiPRPhI8Jsn1zZW+6BBkmxPcoHjFY6El0fnM+LiNcWk6S6d9ZDdWSC8qavS4rbUMvtNHUhgOtmZpWh/+z9/jny9ngfPMiDLo0p8oCAKov9qpNaQUhPxWsLJTczlOCMMSc/ZKVgl+MWdL5puvZc+YnC6IN+0DalRhaTg/Mc3qS51dEZaOfyR8Zj1Gndu6mB0r4kGjsqhxDbTxaxEDGG6aV31SjTAJneA15v/BBnSado3aCYBcXio7UujkH1RKK0p6EfG1Rb22BAW+4Lza60L2yZRv9LifoFUG+gn0geZHvncuxsE+UsTF4pKWGAOLQcJ2ddnrqyLcwMils7PZW+m+MlwIdRawth7PNg/NuFGAg9Q
 4dM+AfkP
 3QbfqV5Lk5H0Fu0W0T8byxWoP8rZy4a1bok23IeEuOT9W40Wu1S9i59lEAbXeA+VSAInTxAON8aSg4iLCebtXrKL1dsdAP/GUDgs6itQmGhnpwrg6irFdAzyCpx+bYxfY6ix1SDSp4gdoyFTi1jjroWzWG0Yb3hivKg89XLBWd3ypSZ5L2+Qwq+1xRkueR9lWaI83pj9o3vjz36aNPsF3giEeXHoQJi+Lmri0Wy1hSnxS3yMtU5Vdn3xuOJ7c3n4FWz3mTx9EWoP5xzwGqqj7EkOpyFgjM8twsbZHNcDTFqmEtZcZ86BVnt2A+dlJBEbxqrj9CdxRzwrOMrpouUS+N0IVa7EYldQnv4HQ+/IQQ6UKK7bAgs0Z2GXP3XKXtvygfuvawbSYpYbvfxJuh5DWGpfT5wPTMoi8INJNC9rnandXm6HBfjxuJ+Mn6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 22:59, Michael S. Tsirkin wrote:
> On Tue, Oct 21, 2025 at 02:59:16PM +0200, David Hildenbrand wrote:
>> Let's stop using these function
> 
> these functions

Fixed, thanks!

-- 
Cheers

David / dhildenb


