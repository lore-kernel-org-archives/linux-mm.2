Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0921CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCD98E0031; Wed,  5 Nov 2025 16:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A52B8E0002; Wed,  5 Nov 2025 16:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC518E0031; Wed,  5 Nov 2025 16:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E10D38E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:15:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9109CC049D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:15:59 +0000 (UTC)
X-FDA: 84077810838.26.FDD4B59
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76D4E20005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:15:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2ZhktBy;
	spf=pass (imf03.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762377357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ppaE2LQfT94SEh9VKLVy8mNImdVN7dwxyvCopktHPk=;
	b=n9VDP+1TBtW8AIiqT4n2EvQcpZIehDUp6JggA4OWWUfjtMDul7Nyx9NJHKcHCGKVG/GdH+
	lQ+65Z3jqy98CamGHJZhqb253rsTFl5H5REnYrrI0EQpxwIUgPxCSO8fNvZ1SIoUSeC2Nb
	IuviH1CPlkAc+vuZKmLtkzA08HYmi8c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S2ZhktBy;
	spf=pass (imf03.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762377357; a=rsa-sha256;
	cv=none;
	b=QR3leLBCDOcD1UGYOccfrFLM95Drt38sKRFhdTlNXTPDFlYR089UbrxNjbNOyKz/K6Fhnc
	eBD1X2ps4NC6jBmASSiuT1I8Ad4eirINQkL4yAPMFChtpmN++2O2WsneLp1ZTMlx9zNCMA
	L8TjAfoR1KxV0OJUVbZFMEeLnwNJEM0=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-421851bcb25so148660f8f.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 13:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762377356; x=1762982156; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ppaE2LQfT94SEh9VKLVy8mNImdVN7dwxyvCopktHPk=;
        b=S2ZhktByN1x9qxr10txiV+ty+OMnNG+a/NjVhQLqtXosn80IhnuTSz32XblssjVm3t
         K1/7oznFU4ilhNZO4Cw57MkyaDmt18fzc0vnxv2bPh1fKshUT4SC+ERH9/suLO7AxN9T
         PMLvpzvahjuQM8UovkoiCbZo0QTmkNbSl3zZmqCnWEvV/9/9zg0fimD4cHnNQtCgdppc
         IkP9R0hH6vs5NwAysF1FVZrCCks3ALqFQ6WIcg0D8uaNwwKAnuni7I8d01YY/uZt4UW6
         JvxyvE9z8Z2K75ZhPBkhnqeOmxYAi02SduBrLxWszMpNrsogCIdY4EJT43Eo9GeXIlXA
         WohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762377356; x=1762982156;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ppaE2LQfT94SEh9VKLVy8mNImdVN7dwxyvCopktHPk=;
        b=F3aMgenhVOA2/dSLQc0Z7ToEJsr9wpn4YTkcSlApGD4Y4WUIUQ6d2GVb0sXzblkQOz
         oXO/2C53ndWsuxXl32dZUBHqAc/x7AphTcT49s6e9GSIeQb8OQdUi2U55wcN86pszLOP
         wmPiRek0KrgW4Ymj6k0SPAM71eyTK3AiXstlsjWTskDFfHhNXzK9nF/jF/dGiMZj134p
         TK07LMheSSaPYmN8Yk7NLkDJdXE0VDRI6fiOn+oMzYn6UU8RFHjzzVI+JkV0QMxgIhp7
         5qZGc6uemBZc0hr3QqNEwBP5DYMRxlquxotDK1pmQLdWHohwTkGatE/XNwoLB03oaveA
         W/jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMmLe+xMGVQ4Bh6zVo9rvFKV9g8Tssb699mojbQCvbm7+XZ7pTR+37P9u+/IVZZwBi1u9455HXkQ==@kvack.org
X-Gm-Message-State: AOJu0YwQszVRDAV9sR4GY1HjHynqkzRXiH7O0gfT8cakZJ6V19pg38JS
	mzm52ZhqpXkuU5GKfwAi8ePd8+dJp5mO1WXSOd34EWQmk3A33dOD4h18
X-Gm-Gg: ASbGncuSi3GG7rj6y1P2EWo11Y/euK4FnbEL4QJNmJy6S+sQPylcdI3UllDaSJdLO55
	gaUbFrg7aRqql22ZGoJA+aNa/nSm08z/7unrWXowmnTm0AgbvtZVKmTvOYoITa3T7CC7FWpNqSQ
	B9LP6xbniFguAd6KqUGC/RR17+OKo9DW2sHpbtgKzLJf5FJRtaVq+o7Xm9DLLWFJW38rbXBau53
	weEvBJiH/dMd6ryCOe8HFGGiqKGYDB5S2Jp/kqAducjFCrjl39n3kkggKrxzX8FqM5+8LbuauaL
	xNxGkOCuPcVG9NwV6e3d2O7gMY58K4f9QsO6mSK2twzFsO3idfmmjvX6z22o2L3upvPEyF5pefm
	ADXv5PeJ1Ae2+TKvJCVygRlC159akcmFUmstl8FUqaTQnEPMMj46LKJ6s17YmZHbw6ICRXSVGNF
	vmt0HcC2Id8EUEkhfxynRxer/tkHgyK6xTT1LNQZDBHHKNjzJ45tm6mIFEN2x7Hk81zn/8ox6l2
	CLCHHbicGDr3RhbjFCqpp3yqTERSZs=
X-Google-Smtp-Source: AGHT+IHhnDU7C8JIw0mU7ueaGAVALbH7ZSUb6hbiggFXfD6/S5ypV4gK3TS5wjxW/SnnCtFGhSbz5Q==
X-Received: by 2002:a5d:5f53:0:b0:427:4b0:b3e5 with SMTP id ffacd0b85a97d-429e330aed4mr4567372f8f.47.1762377355551;
        Wed, 05 Nov 2025 13:15:55 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40617asm851462f8f.10.2025.11.05.13.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 13:15:54 -0800 (PST)
Message-ID: <563246df-cca4-4d21-bad0-7269ab5a419c@gmail.com>
Date: Wed, 5 Nov 2025 22:15:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
 <aQus_MNi2gFyY_pL@gourry-fedora-PF4VCD3F>
 <fb718e69-8827-4226-8ab4-38d80ee07043@lucifer.local>
 <7f507cb7-f6aa-4f52-b0b5-8f0f27905122@gmail.com>
 <2d1f420e-c391-487d-a3cc-536eb62f3518@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <2d1f420e-c391-487d-a3cc-536eb62f3518@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76D4E20005
X-Stat-Signature: 8p6s1o39a1qex8qtdyw4jixha6g9z7nn
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762377357-703375
X-HE-Meta: U2FsdGVkX1+ctKYcJyBKXoJi4GmelmMsCx7ar8dSFFpWJp8ODZRltI7MOrBptJo+kU5hSxyRZy0FTmKF3VlVj1iC84pqam8duVWpiol2HICQmrf480IPISiUdyrrF++jSoj/6EVqW8XHyEi5AUtJPHsVdH2e7GKEfZo8NE9zYffLY0PgKrj0yOOwokQ0gTiksHWovjy7r5nrffbli8R9oA1R06LyM3pT73lKvUptu3KYrN4J6hVpUG2W1MWNJlAwgfLYxR/XQPH/D/EeXys0c5WJbm+K4+ZmwEsS93X3GcHrn7yXabWQJ9JUZ0uJl6sgdy6yLd1ybF2rnE+qL26Hb2nj9OMZ+TYT3EbaVN6kQh8ktdUnkGlBl5aQoTBZbNDeTwwQbGjxIvwRI0pk29jGwDo6SHF+0lvJ8QipMJvhI4RIzFhbJIU9rSIi3clHGXsY/uuzU85LK8My1Q5RRm1ga6gSAJZznF0ZfPYHnJJuTXnWI5OfkyPvcEpV/GYvSTFLUYHgDLEo9JREswY7cE90gXGqgMQS3YD7HfmzsPXVy9IFHYMov29qg4W1G2/v9vYSPyE14wPZdHKjALBhJp8u3cOufbeeji+HcGh9EHJ5trVuK5bln9EvfhFm3KWjZeCAXW3c3XCDEqD6l0mZHE3vY2zuNd8oe4q/koSbZZlbaRB6LmU5VS0QyQToeFLHxUnvoyn8CAcyrvdOaqMMbnVXF7jv0oV1CNCJB4O0g3ULabIQD0d37lekkYtRXgIxG3wML/Vv2pnrO1I3pc4ZbjLIFIz54JynaQbrrFq43d2IM+xIfhbCfND4V3AWyn++w3PEVNE7IL7AKiFEUU+O45Fiki8n2k8mX/UkcafdXIKq7MqirJwZQGfFhMkDaFBTuctJl7pVbC1FkWP3bhe3EVzb4dLv7cbEkfIjZDGqjPtiTS1sEnO04a0rBFc7gSFY54f+0JP5GoevU23Ux8Gu5CG
 e3ui9ysA
 fbcfzecHhRq3gE+H02M7TtDx5QilHToqOzHhO4L0Q2xLzt+7w8q9FKIcY0t2S/DDnI3ZammFFzOMQwZkAArCnfusO1DdKtHX2BjOGEnrH9pJpBMIC5TTY8PY2+zA05JsHJ8G1HJRT+NamHbcfN9nXchRgCg9Pa+50qbfATf1sIT5dX75S/Bs62nGtu713TAUGxobNu8/4zcc1Cbr1gNCf0H0BoC5sZx1PLTcdkyq9OiRcFadyXBQZf36uP0igtgaN8fcUUrQDtH/g4Jwk0A9vZ8gZS57xqBVPsP5KGXS6J9QM1eb1J1B0F1MIIUjz+GNMK4iAfXOJjHcxUmF8d9IkVsXe8vSyivQqnxs1vPf9SNlKsgkBZTTUvp9sM0XzQPmlNlpSWkq7BTLWr5tu5lpoAHlH/R0RQ8KhGvVjH/CEYqqBSrXsUTCBbl7i/aYwxb1wb/YD5OYUGuF89901VK946d/Ns9Sbryl/NvEC76Jnu2ooVAxaXK/ijZG6FXjTuRgGxWPNk5twE0FtR0LasBKc2VyC5Mc6SIuhSORwLp61OQ/j7EY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 22:08, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 09:11:45PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 05.11.25 21:05, Lorenzo Stoakes wrote:
>>> On Wed, Nov 05, 2025 at 03:01:00PM -0500, Gregory Price wrote:
>>>> On Wed, Nov 05, 2025 at 07:52:36PM +0000, Lorenzo Stoakes wrote:
>>>>> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
>>>>>> On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
>>>>> I thought about doing this but it doesn't really work as the type is
>>>>> _abstracted_ from the architecture-specific value, _and_ we use what is
>>>>> currently the swp_type field to identify what this is.
>>>>>
>>>>> So we would lose the architecture-specific information that any 'hardware leaf'
>>>>> entry would require and not be able to reliably identify it without losing bits.
>>>>>
>>>>> Trying to preserve the value _and_ correctly identify it as a present entry
>>>>> would be difficult.
>>>>>
>>>>> And I _really_ didn't want to go on a deep dive through all the architectures to
>>>>> see if we could encode it differently to allow for this.
>>>>>
>>>>> Rather I think it's better to differentiate between s/w + h/w leaf entries.
>>>>>
>>>>
>>>> Reasonable - names are hard, but just about anything will be better than swp_entry.
>>>>
>>>> SWE / sw_entry seems perfectly reasonable.
>>>
>>> I'm not a lover of 'sw' in there it's just... eye-stabby. Is that a word?
>>>
>>> I am quite fond of my suggested soft_leaf_t, softleaf_xxx()
>>
>> We do have soft_dirty.
>>
>> It will get interesting with pte_swp_soft_dirty() :)
> 
> Hmm but that's literally a swap entry, and is used against an actual PTE entry
> not an abstracted s/w leaf entry so I doubt that'd require renaming on any
> level.

It's used on migration entries as well. Just like pte_swp_uffd_wp().

So, it's ... tricky :)

But maybe I am missing your point (my brain is exhausted from uffd code)

