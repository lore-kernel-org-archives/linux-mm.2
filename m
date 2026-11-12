Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE07C606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ttzzEc+F
Received: by kanga.kvack.org (Postfix)
	id B501E6B05BA; Thu, 12 Nov 2026 11:37:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28916B05BB; Thu, 12 Nov 2026 11:37:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A190D6B05BC; Thu, 12 Nov 2026 11:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654736B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:37:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9F181A06BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:56 +0000 (UTC)
X-FDA: 85427023752.05.57A8D18
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id D597120007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ttzzEc+F;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501475;
	b=NL0MASImHBruUsKgQU1c81/FZHGc2+Mfo84j7Qo4+xiu4xHBbX0D3qW2RgbKriIyZv4twt
	tPhlYqpx+etkO8ZgTrG3poiMC2WS0P4+QJQ4W7i3CzOSgM3S5z9627zPDmfs/DVwkJajQZ
	Ml5J+zQq2Kfs7H34/wcgP3CBcCV7HLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ttzzEc+F;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvjirMgHIxC88ZUFqPd+mUQ9zs5Wq4hvPV8uQmDh82Q=;
	b=4LD6xdZMjSAwiDHi1jCw30zcuWzIf2AsEpd6DMstYaTAHf4o5AUTUQsRe+uRlU/I6FPDFy
	8qKKCVztBF9aXiLgG5vqIGz9UIGVSVoD2C8Lgiv5A5jNj8puHkRy3bHzE5tkksy2DJiZIJ
	LcwsgRIZeSicahn1eQ7OFL0eORKsE+o=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-945e6d9ceeaso382880085a.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794501474; x=1795106274; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nvjirMgHIxC88ZUFqPd+mUQ9zs5Wq4hvPV8uQmDh82Q=;
        b=ttzzEc+FkH0CxyidUE9ezbKWLPC9XhyFYFP8L9FlmIWEVSBcdE7MO0ai/KN8Xply5e
         qQBM0nw4AXnn1lvrdsHG2uUfE/oKIeuyHCKk4D9uHO3elJst/h+TpO237jxCRNNO9xhx
         uP/yoYE/1SyAZ29p0csBVHWbY/enR0LUzwZ9QsZBXsyFCgjZyUo3MiFFyczyQG3ovx3u
         otsP+6AF0XHJeaeC/ahdFQWks69uUzs26qkDakJ0mEVI5ptsXfV81szyJVZ158iOdylQ
         h+GPvAJDNXj1oc9kz4MHweIoKUhrneyZNNMcbDvo8/F7Qb6Yys3DOnIkU8vpP8B4qa1q
         o4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501474; x=1795106274;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nvjirMgHIxC88ZUFqPd+mUQ9zs5Wq4hvPV8uQmDh82Q=;
        b=scBRYnmycLC1if9o0GcombFPeb8Iqurgzc6eLfiyx5PLhVicW50nYeQ96sgZlDTqQE
         ql1aXoBPxoCvYMuB4VwqUh/9u644xBv0nKYpXOB3P6oR1JpLSAMygxHh3kd3pnABZaNa
         Wzspu2Lf3OmMpGjktTE6snZFgq1iUNumlUbysRCN8BA7UhdDwrlzKLgCygEuLG0lCh7T
         24qZv1ykNbYmReQgFOD++CRyS7wnHUab5Fp3SkebBI/jrtNYRTPu1XyZNOKE2myt/D+9
         euoN87uSzYHl1hOJNuVCfDqRH2YYjTGdZqg6FAa78ZQA2O0sGyIn8YDHGR92Bo0JXaOI
         Rhbw==
X-Forwarded-Encrypted: i=1; AL+hErE7bnnhQPt2bpcTDPzf0fSvdLneHUbrcJ8jqPfpXcaYKRkNWZ/sC3wNOxa04y7Lz73W1L5v0KEE6A==@kvack.org
X-Gm-Message-State: APuU4Z+OgLMEpUtJCq5sNu5pXCf1BKt15aqACfoZusqxUmJbaoIfoQ4P
	oQjX+mmTiM/Kn+Gj3KE4RhdXuTGlIjxID6aYAAbLl8D9unmyBHBw+Knxyftbqxd9deU=
X-Gm-Gg: AYBFou3EdxrNkMhFoPYiPFGbsimhHGrGqopA0lakaVmZLgA3b6y9H3SqKdYWfY6WS4j
	DiS7TjgxjUlYxC2ndwXQF08bRprE155Ft92LWKY5cIxqofV88EExmjzoWTWkc1XLSk0+YNqKwCQ
	eTJ3nblu00NTflN6iqtaK7Aqsak6l552FT5yv5P0SQi2DEVJ13iXedKKBgkmI4uaJIcAJNv2vE0
	3tALfsL/diaOO0nXhL7rtxj4ExQnvAsxMLyCp5ZUlgH9DHe9paDRlfVoByED9XgUhmie+zh80JV
	KCiALduhoiSvIvr+EJlc12N3pTO2YAbPxv/u8/F3qyKM7lBC3wNM+LWlbj3JuhnleN6su4qJ0v1
	tKhCkwk0EfL0ZoS9ct282nXpSc/5gquDogQA2gZ6LxLLkR6+WXFN71BxvTcucYMdB/qEvsx31Y3
	Z8ZTreZROs3bzLac1aVCMHrT9JVaq6H90GeAmr2VTJLQISiqpZqlGOborHuQ0I8OYqRi7P+q4Hz
	TJGj4GkZl7KpesYBcW5TFDebREfOet9y/cmDZWZfL12AbtNPhnqmvpogl/sVGlkxaxXBidRVQ67
	dZLMICcNdpSBTcPV66zHRqEUC85nUPdtt0TB9aELNb5C0pQMuTtJ5gAAojxbMko4sKrpks5DlEO
	8pQBXqK8=
X-Received: by 2002:a05:620a:28d0:b0:93f:1e3c:4a3d with SMTP id af79cd13be357-947aff8c925mr1038556485a.46.1794501473963;
        Thu, 12 Nov 2026 08:37:53 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f02df0333sm51261056d6.27.2026.11.12.08.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:37:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/13] mm: cachestat: count each page only once
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 11:37:52 -0500
Message-Id: <179450147215.482102.15685424149106944496.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: fd3k8zmaou9tcjxi3dii9se6jqbo5ksp
X-Rspamd-Queue-Id: D597120007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794501474-376879
X-HE-Meta: U2FsdGVkX18hJWs7ZjAev017LkmiPl5MiwDA1UN0BDqdJIXVkMbUDKTIjqu0lK282G5AfNtVY2zb+oM0E1yQsy35dphuqwwoFvtLYi8j2yTVhsBUJD1HF5Ma+xvC9yKDy2QfX6PxiH/dL3nt2uCASJP/UixIK+Brta5KvPz2kSvOaWyx9SyPSlb8J6F7wMzgO1x/0rTobpCfiEHReyQlpBAaeP3/mfLLvu6PeM2/mtYTDDbWdgnbKT2Q9nYYd7gUWekYy7Zlc1UR4Jw+BBn211UHL9FTfQ8AUrUM4WaE9K383O7yj/p/aXH3Q86GK7MvQ0AhqRt8l5QtEhmvRmbw3KZ55qN3bCMdQvYxO1hsgLhwv2pBi7GLpscukUHK6Km2hchEG79hlMPGcofMV15CE9IE5sXToepTkKTM3eqpQ+JVAZ58xY7SvZ7h1x7w1X7NR9D6POeBayyMo6zYAmYe727gAvCsrxkWnck3a5G8uMIXTuw5CKruoWBu4toSMAG6qPEM9NviAwTV++bKgSOoCSmCziRUlGK/jB1ZaBGD/lLm9OLpULvYvrCb+vjlowhhId5GVXpmvEePzoKCGoaBS2iIFbOSCdaAkPnstso3AtZNSAJdzQ0i/GeuWAKsQinwq4h62xerRvwEHIkRZ/WgWW+owM5ScmWv2HIHHgOcaSmuze9j8JvNVADupge84oB2NJmRywhwppF28cKK4FMoAmPgBiQLKi187n5zGeAAsSFVefZnZfZGcORpM9WB7aMO5nH45Dc/oR63CRhbDlENQikAII1bIgJV18bQ5cOR36t/dN+ZZdz5BxY62XRXCXXrIb9/zNAr3eJv2yyvWXKcSg2jLrGbKnKp5ck0zHfDcgkqcQWSuilbhEC0w9v8n2Dch5ABjQeg+X3S9+8cLcy7bPZhXB1ijSoMmzZ9W+PJHGLdTihx9lHGMxSxpbe9UK1moUB03jckUbRhWbXt3Zd
 VPQJGc9F
 68uQGOM2DWQEqNSvN5qdFmPmdk0CZO8PkogcvD0nB7i0ohS01/D+o880DBV/culsXw8hclhJlrDNS/80rUFgtfJ+9GAFi2CVwB3j7dWDW/abmCF/Z90vGS61qLu6h+2iFdKimZminqzxJ7umWnBhLa6HvWuR9vWDW1NfdMtESHs7SLskbHkDyGsFhKWfK6mBYOCfJI4TapPa1eIHx3xATya2dD6TTF19jl0HfDuj75OVQzskkB2AIGJOyne1Zxz+5AR+jSxOr3adA4HnYY4DKsIt7VlBl2sdzHA9qM+lhMygqzJ5TH4llmSZT98DlHSyM1Do61X08UBf/6IVSn/eJNhjd1avqU+AcU4yGjcM3QWThsws9LN/GzfE8xxShUmI5Q5M2Bv/OOhgHTN8h7RLXE4gkvc98c1Z+Hg41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> It turns out that filemap_cachestat() can unwittingly return incorrect
> page counts, if large folios are present.
> 
> This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
> kernel if the input range starts more than 64 pages into a folio that is
> split during the call.
> 
> It can also occur due to pages after a large folio being skipped if the
> range starts in its second or later XArray slot and the call reschedules at
> that folio.
> 
> Finally it can be caused by pages being counted twice due to folios in the
> range being split or collapsed during the call.
> 
> filemap_cachestat() walks the page cache under the RCU read lock only,
> and for each entry it counts the pages that lie in the range. It does
> not track how far it has counted, so the counts are only right if the
> walk returns each index once.
> 
> But a large folio can be split during the walk, or small folios can be
> collapsed into a large one, and the next entries then cover indices that
> were already counted.
> 
> Resolve the issue by tracking the current index as one past the last index
> in the folio, and explicitly using xas_set() to set the current position in
> the XArray.
> 
> Additionally, add a check for folio_last_index reaching or exceeding
> last_index and break out of the loop if so.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: updated to use curr_index, fixed comments, updated commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


