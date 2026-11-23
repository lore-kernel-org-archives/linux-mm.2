Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88803606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lv1xRuBf
Received: by kanga.kvack.org (Postfix)
	id 985AC6B05B4; Mon, 23 Nov 2026 00:53:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C8A6B05B9; Mon, 23 Nov 2026 00:53:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872AA6B05BA; Mon, 23 Nov 2026 00:53:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59A2F6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:53:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA5B5A0823
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:15 +0000 (UTC)
X-FDA: 85465315950.22.87718F5
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE3E2140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lv1xRuBf;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795413194;
	b=hUZkZQiAVo7YGhpaDzz6me8Y2u1RG5+s48aAoEgfrhBXoCZcEeofs6ZWhjSGP+ggGVatxW
	S+2kkpENVMtuBHl5HcZFA9EdHV80/bUrhxqeGSiyftRPHk9Cj01nWNqE7IMdUTzWvRtjrh
	Rlc5Qu3O9d29hTRAqg/jyEx9q5PZ0XI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795413194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQLd8QgogrHpSVXIhi24k1QGI+Nh03QUKUs1yU2g3aM=;
	b=nApkiaWYpkbHEKaU5M9K0AYw7228+OgjLaI/4M9nz6vw8lIBiVh0YxRRcymlCGmh+oZhCi
	E9jVqywFs8JEbC1dSSIZZltZyTgTOssYOhG0UvBN41NHaawvXS3j7EM2EVEsuocH6++KGW
	sGBs2rdgSoC4Su+mgm5K/JW5eUJlAEA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lv1xRuBf;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b4ea3c5afaso18253477b3.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795413193; x=1796017993; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eQLd8QgogrHpSVXIhi24k1QGI+Nh03QUKUs1yU2g3aM=;
        b=lv1xRuBfNqm+mrW6o89EgW98EBKPLasi4HGYCziA7KdO7NuAU+HfGfkM5aHB9tTgmV
         sIVkJMefWKaj4PcnZIJgrRw+K8V8Gh4WNS44zVkv5Eti8VNdorrtNiuUJ+FTC0NP018b
         uButqCVATwYgjcwHVdGbQigNYjpvPZyh/HZ0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795413193; x=1796017993;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eQLd8QgogrHpSVXIhi24k1QGI+Nh03QUKUs1yU2g3aM=;
        b=U5lvH5RUaCUKTOzB/x5jxMapkLnGZ8827drxKNfpAFnk1+Uh1ELdbG8tk7BmcTjEh7
         1sVtDgcHz0a8Ip/M3Yg4mwW2Y6RKlatKBzrg+yIHInvz79McE7hDRGAagClzQKoWVPFF
         /vabUe1kK857XVlsTBPuQy8/nDg/ttI+BoBRy/eCIxEVpbQFyAyWkdt/xFR5kFvh4+GM
         AQEjNMX+IbzAq3ZrvzSrcISI63uEWG9jeyOtf2HmGu9mqbVg+zkSqi/PnxTPvhajV6nl
         AMXZ4W8PxXMbIxWfgQnn1wv1P0T+x9kx1LLiDZ+TWpufdqeIgcLmt/3lCTvYOGgx0gIT
         aomQ==
X-Forwarded-Encrypted: i=1; AL+hErGX09qm4TEOX4vxOvfn1kjxbBvTdLpjgJf9Pit40wyt2TpBNoJ4cp9xWmXRTrIyREPARDy6T/TceQ==@kvack.org
X-Gm-Message-State: APuU4Z+ZGQThFBiqMQ8OT741Khd4sFx8ej4Sdj10Rb24HTBZfUWRY3Zy
	TVp0U646OJI8tWl0N0HF3AgribCHebnIaDM2ha67tqiuhm9sLMdbS+reXxvA9ieOfVc=
X-Gm-Gg: AZFdTZc+Bbqlp9jT1WVVxzboc2252JcJnBB88Z3S8dVXLwmYh9RhTZ+UEm1fQVF1pWG
	Sb7XJrPVspcRyrUtjMNN9ZXgQhyiH/3rID4OlNMB7W8SAaugyEsyiwt2XRUn3SSiTpydtiCdfnb
	jC/neZHW4wTcSMzWAya23cQ+pMeL3aqDEgFcRKFx2oNP0m3rrXfsGo45s2RroHVHgRBoZirypkh
	XM23UOwcRriu8k6y+e41RYkAJXQ4BBQgvWBYIk7B0ssIkH1A59n6aQmLVgOeHLbJQcIUfiTKbjq
	ruW8+wVROPUpkL60nQmcd320B8ZJkz3pAz3QTtpv+zWVJY89BfIZFDZMKwP/jLMVz3dqtWa1Xjf
	H3BuDD6xULhjsorxIldzEIKxaNYgiMIN/XhzQZYvEC6G+rJ93cys8I8+OruOy2eZfxNTOz1YlRu
	v9eIFfjOeQq2l5H/xIw4jwOCSZZQxwx82QO48PX8+ZM9rVyZ6stWxgM4M1yMncmHdCkY/M7OISf
	SM/pAvzVRhEFh/Zd0TLBVjx68BM9iSUfGbKbYV3QLhNuJyMc7Kloez60XqDA2k/PISLowkhkh8H
	YD7uCCmmxP2hF9gpArSnw2fWbb6xY0ggNwscSdD/DIv4g3omfxhuC8nhMQr2lQwSgzTmtF9d0Cm
	6zGOz8R9d1uRbAuByqlT2tTI7ZmWwmPWWhNs271Juj29udSGZ1EnVv6N++zO24kpsq0k/fu3OJ3
	Eb3NiD9j5aJOHWyfqZymJueKADPEqy4pcVp7TAga+ZKm8oQ0eyuBmH2buM1oAikLnEOy59AwsZj
	9o4cdzkG/0JyBiebhm4LPYwLIKLYVKQ2SVkLLbXM2mwjF6+U050vq1KgLBcQinsXw==
X-Received: by 2002:a05:690c:630f:b0:8b4:dfc2:be60 with SMTP id 00721157ae682-8b520528bc4mr36338177b3.107.1795413193110;
        Sun, 22 Nov 2026 21:53:13 -0800 (PST)
Received: from [172.20.0.3] (static-host-74-205-137-217.epbinternet.com. [74.205.137.217])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5202dd36dsm41031237b3.26.2026.11.22.21.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:53:11 -0800 (PST)
Date: Sun, 22 Nov 2026 21:53:09 -0800
From: Chris Down <chris@chrisdown.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 0/2] mm: fix deadlock on the folio lock due to inode
	eviction
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <awPUxY7eDWuo_5qP@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE3E2140003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: o8ohnokhmt8n41trzjmyrfu7yms4dkss
X-HE-Tag: 1795413193-212138
X-HE-Meta: U2FsdGVkX1/t4sOAzhEUOaiN2wiAEHnQQlOaB5N3kQT/WaB374nq/lAR1bXWp2UPipsxtw5ENCl0+hibLmAQ3thG3x2dIO7zAt2ffg/iJK291dngP21Te/jJqRoQfhpj7gtFWIKLRDK+gH726DExuGL/i1J3MfGDKquotuLHGBQjL2+Gq4IFUKT3huoC5QotVtvncuUFtzXq/K85OXaMwfrrJGy0W4q18KLkzD+neMRk5oJ3yt7pqcfpd7t0tkrPLUFiWT7bn2j9zEfyQ7JvYij8jp0uC3xhwgX/l0CEWWhIUMYmPwSQmDbK73UpdAMQAtvoJSZ6s+MM5c5eO+YPFv84UeJPeGiqsBgovCdcKXVIfNSQ0LhO8FuetrYXeTkyQXW47TW6TjnVNLh7jfF+WWbwyEu/Xx7FPCaES6RYOTCYhNubkB88vEWUTBXWBLc4w4S4DqjDTuGJhFMEjnoJjyLU/z0dd8bntjnE1C2SPZtDK2reNSyjOsyDU6PdPDoVc9LL04QqrfZJyLLmQuK9bWJqw/G5L2sUkm/QqGmfJI8nL/NvyqXua07ZNX+f4+qdMeXLRG3T8b9bIthntbspJZ5SxUsQPJhGTF5AlDXzEMKqYcc9cLV9GCofZxxU6Z56L1LFTda0IdpGOf4Ch2ODQyXqhDhrty+wt6YyDRXFbGkM0vJyRdFMmdL9/Sm1PADaNWCI0Yg8vwin7P1zIPl6zxb6HfesPvGWyflKpZnni0t4B0vUiq6xTxxTtqQIPpt4UVrqtiIp/pcpf8cdHqZ1v5wl8ojeoenkK21HxJAWScM3MY22LTGAgeI5B3wp/ANf0X8eClpfcGsEyqku2VSG1b4Ye8wm8Va3bN+5KQ2D5g0grDyaE5ZVolMQ5KWUlJ3rqdwhG1WQnMNw0F6ZDVuV77jeaqXHoL7XqRd1bHimz93Q1MkP+EQDpZe4q0AeHBkMNVg+l0Qp5Ge0rA+vFsm
 SHwQPqjL
 VT7ZB7gkq7PGkQtfcDDaEoJWdTw9bqj8ARPBC2soEzKv0XFneqHcZsBqVaQKSgrYaFurBO4QL3pBe+PtGXfWUy0eCQeumUzcCtRjo/hkdXKTYVO2Pe7C2Xno0hkLFmvD6omAMKvfyRBnru+8iWbkx2uO912elOWf0t/bT+os/UXcHVatyxk2ax4wbjnzC4V9FG9wFDVA6I+EL7UdR4ap3dA9ZKaLbr78y/9HS0e74FNqLgoBAEGJWidiPpI5WtHBlIcaA25Gfp7U18hq10ZXfpjBpHU7fapWwF94Hfx39ttsnwNtHeiLrnuGgarJ9Dig0iH/GtWJ0IA0zD2vGCebdwN4jjXjq+516EolTcrXw5vShWlHAlvL3ihsS0z6kH3efATiQaWn6dz1YYIU89YpWBU0CZ0GuXYkDS4kWt9Pf8kQA/1d7L6E4pxW5xrJUZstlSV9s86IkimQBz88tTSBa4vkdZ2+pMRWuYKpf3SEpEUqd8caEPwbWm960wERy/PhtYK/XfTD6RiChN/DpsoO6Vbtnk2TYDxMwZ+5lIPh8126zaeGUl7HhJdKo1yyKZq/UfMvNC2z9ZbaIvCGeTZjcwykfmt5XFc6nrzvDIS+NzO/9qRcL8VNo9lxZqqdWuuWX793E85s3NJUMezWl6+zDK+6btYYQHtxZCyYgSvyWZojWXGFuqdKi1S4suUdc8czzCbiKijdyfqKQKCRZPdd5UAzrRue/eLUnmu2BQkIdhFZURi2cZ3WzyGRuyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Thanks, this looks good. I exercised that in a VM:

- with the series applied, migrate_pages() on a virtiofs file mapping
   no longer allocates destination folios while it holds folios from
   the batch locked
- splitting a file THP no longer passes __GFP_FS to the XArray node
   allocations
- and the migration and split_huge_page selftests still pass

That said, I didn't manage to practically trigger the deadlock with a
virtiofs mbind() migration racing an unmap before this patch. It might
just be that I am unlucky though, and the code looks correct.

Given that for the whole series:

Reviewed-by: Chris Down <chris@chrisdown.name>

Chris

