Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC727606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SNqNQyvg
Received: by kanga.kvack.org (Postfix)
	id A2F776B05B4; Wed, 28 Oct 2026 04:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF416B05B5; Wed, 28 Oct 2026 04:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87FC96B05B6; Wed, 28 Oct 2026 04:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 404846B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3236C0BE1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:33 +0000 (UTC)
X-FDA: 85371338346.10.C86B857
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAF3B180005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNqNQyvg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FU6Km7ChT8wB3iaSth+F3/69ecBIaf5N/Fzbc/bbo+s=;
	b=Wkj24gX419h2RsD/E0gbxJeECJ80mEoFlbMWTZYfzZC1f9dA494okjwHfJyOg7s2WV0SPH
	cOxjHV1y5FpL+zF7mh+Vskrq0qwo2t3upm6sD8QJSlm2sLFc9H+PdObUjeZzQk64FZxn3e
	3ZOPippOtMhgJWT3XvwXHm9NeIreIgw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNqNQyvg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175632;
	b=uenfLAPjltQn0TYhxw/XVLjzzSiBi+Vcg7YeO28aMUl1+zpJuriy0KXWc64cRUQl2s5STe
	EPZcoN9XgbuOaipyXif4qmQL2qGbDrzs8P2sc7aduyTMOwrOg+q2afGvpLkI/VUL8sBTNh
	WTETJsgkp8BR5UxmMF5F7skYrwWHRx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F2D341790;
	Wed, 28 Oct 2026 08:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646B11F01825;
	Wed, 28 Oct 2026 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793175631;
	bh=FU6Km7ChT8wB3iaSth+F3/69ecBIaf5N/Fzbc/bbo+s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNqNQyvgTJLYYki1VSd8Hcl0rY46o6Ox7LSXYq2rHJNhZE9s/g3SgZzKk9TbyXUej
	 QsuLPUFbAhBZHeHF9UWjLtam007zqSERpnh+0tGF74wfWrl+sLxVERrxh0sBw/OOlK
	 peUvcnC/7tdlAtykO+TZoTPoFFw+PB3f3piMINdC5IaYi/RN6nqY0rSmn8TNYUXbmN
	 gR3tsZvNx9LO6bnBOLFwK5LVL9+iXZdynSfHTGPwCtgL75QSBCLou55YFOuqsxmPFR
	 f88pw2cwS9M9t1RMNZr3D4E94Ab0LPajqMQgHoQgM1wtehcupx1k15Uja9JjYn2IIV
	 l8lmiV4u8XSkQ==
Message-ID: <6633e2c9-d4c1-49f0-a4a9-433fcd8b3337@kernel.org>
Date: Wed, 28 Oct 2026 09:20:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: Barry Song <baohua@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
 <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
 <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
 <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAF3B180005
X-Stat-Signature: d5ef1u4bt59wo9967n1hd6xb6bbhq54c
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175631-200232
X-HE-Meta: U2FsdGVkX1+/HBRGCR931aJZQTl6biTU49WW5TZ5dn3oenPf/n5ihIWKsVxNDKodPLAsSyO+c8JmjrFb2aFrtrGh+XDu4Ji4NLHjIh20IpBp+aBhekDm4fO2o4+9agT2ygidgn6dBtSvhfrGXESsNn1OSn7Onq5H/XKZxOppAFt6/HS7wBXCriTeKe4cD/p9pq99/oyB5Xapwksj+09rhviaUP/Uf0eOl5Oi4HF/SlqsgUi7Tcx3aCNnCvdsP3FYH182UDsZcBOwXgF0X58+RrC0nLg6swndS9hwBDYn5xdos3mL+cKJ9edKCxjX7Ik+w+B67OeDrxucwGsRO+1I5XjT2ULhqkGx3Yw9VBIdcLKcppk9t/oPMIuOqwaPStmKiAYf22O0UfqJoQLf7wkYV1l4+UCnN7Bi9f/KnNyWI/Fx/GCtB58MxcV/yo4WVSQHYIQ4uRxCwdfKwmTg2qyitsXy9t20ktMRdlbLjqS3jrJUUM09hkbghQ6qZo03c886f0RmKNthst7WD2Moed+e60iazhnqfSKc/0FBFxFMlYPF97DtBRZYNvUmN3hwF110Awc1Z0wGouhINnSLQ7U/HgsoYRiBrPPNqGWSfozYX+K78s9nq2yzGxQA7NBR6b95hLhzw9x4biX8RMSy/FrlV8bgLUfOShfOAEpbkvw/8uA0hL8un3N85gvTz6A8iG9fBWaU1xZRCmmbzLy/eOwb575xRhuj9dEBVtuuFqXZCz7TAtzcF+OyGeAIbZWo1Q5xrc6Gk8O4OlM/ykFCrk952OMulXRyFaz6FH6SbqOnlxQGe2oyTkDAgnv8S3m58EIOrtzdOfuidF3PjUrhQK2cqqO9JN/7lmtUy/SlREnrT0e5y4+0TIFYGA7KVq424fEy+7blYyf8CVokkLvqPScFA6Y1NfnLbLo5fZ3Ow6w/2sZtz7ZeqWnuFtAyHE3vdDHVQT+2HYkc9+OOM0mK6Te
 JcwlN3fv
 NfPS1s0sIQiebj19HEZ1VEnXAGSJjEZtMbmkPaBVht3erxI7YTyfG7kI6yAeDNbr/sIniHm4Y5A2m58Mvflaun7FQ3CPQJogyQorvqKR+ZziHQSIOegXhHokb08+O2KkmKUMUN8ipMoSruteJbf+oeS9H44J/q4UKbl2NFxC7xsdVQ6A3fx2HqvG29mgCIPwSGpv5hbs4Udy/xdEACeDeVek/NbgWcPc5GeuwJTiaidCtefsmvTkCWuEajgbjrzzmsYLPaLhhJWXMw8+EN+0dnSY/hj8qou2yQPw+wYaDHjd/aK95Ku8fBL3bekUZsXviB1UBDuB28NNyjr8u7OJSqUdPA9FJNODFVti6fZCo8UhIVPHHQ25y5vvEZz/DOYAaEwaDyODA+Prnq0J/iyAuHAv2wdY80++abQfmxFFr07/G0IwOGUMvpLLtTBPtrg4WVW6PxrZxCEPr4tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 20:48, Barry Song wrote:
> On Wed, Oct 28, 2026 at 3:07 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 10/27/26 11:38, Pedro Falcato wrote:
>>>
>>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>>>
>>> FWIW, strictly speaking malloc() isn't usable in a forked
>>> (multi-threaded) child, but glibc/musl provide this in a best-effort way.
>>
>> Yeah, I'm more concerned about other things that can race ... :)
> 
> Regarding the race with memcpy(mm, oldmm, sizeof(*mm)), we
> still have one [1] even after this patch.
> 
> That is, copying mm_struct can happen concurrently with
> lru_gen_del_mm(). However, this race doesn't seem harmful.
> I might be missing something here though.

Do you have time to look into the issue, to see if it's actually still
reproducible afterwards?

Likely we want a separate fix for that on top. (or mark access as valid racy)

-- 
Cheers,

David

