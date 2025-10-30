Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13B2CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382C38E01E2; Thu, 30 Oct 2025 17:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332F28E009F; Thu, 30 Oct 2025 17:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2223E8E01E2; Thu, 30 Oct 2025 17:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11F228E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:26:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B4EE87960
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:26:30 +0000 (UTC)
X-FDA: 84056064540.04.C145C80
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44472140007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:26:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HIufhEmd;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761859588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgVIQD5aWQ422fzsIKMP+ZLt+yEoc40OBPASzGap/g0=;
	b=jl5gYSaus4Lh7qQ3qrA+Vxm9jh9R/Hz6MZg9PKs7QV51aZSP0o9IRgohMv8AlDFr7K9+a0
	x0vJ10+zMkEpCNmtTfCpc+q2tuNcrQAIMWh/eWOr6DX++Oo1vquepcB8LW+7wGkXRzZBUo
	OKqzMm1YjhegxdeuROOj1ZDpv2JcOvY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HIufhEmd;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761859588; a=rsa-sha256;
	cv=none;
	b=ma7JMkH8uPMAfkMiVC6rFJ8uJ9yKaO7XRKHzBJo0tWYZU6XI9iRljaXY4OEhv9zOvkYYL5
	0uvBqbBW1vbOyde3eEytvdQgYkcPXa/5giVL5rdHlkKuBLyB/c2ED4bj+KBgQjipJsuQoz
	qUF8OaKnGumYXnOtuhLC0evfVjFZChM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761859587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XgVIQD5aWQ422fzsIKMP+ZLt+yEoc40OBPASzGap/g0=;
	b=HIufhEmdp17LSfbooKWjQzWbJohxZgS0MtGU0l0av987bGD0Xsv9XlKnOxwxmCx7W63/st
	HlxOpn/Zd2uxD1ekM5mDZjtAVC7SoouRfUI9DaEwXx+N1EfDcAiM3M4cOiEG/thO8OTStX
	pTihxkRC8T4ipPehLswQ3jJjnR3d+k0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-t2erzDFHMLSY0wXUohFFUw-1; Thu, 30 Oct 2025 17:26:15 -0400
X-MC-Unique: t2erzDFHMLSY0wXUohFFUw-1
X-Mimecast-MFC-AGG-ID: t2erzDFHMLSY0wXUohFFUw_1761859575
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-880047f8636so44800466d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761859575; x=1762464375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgVIQD5aWQ422fzsIKMP+ZLt+yEoc40OBPASzGap/g0=;
        b=sWVpdmAO/gzgVFHSGKzJqgvbLI52qX0AhQWYG4lA9FRPo40//xGCOQTbGoVELX8L4Z
         0vArFX6pVOIznxbKD2MbV1KSOhSZPpFv3mosMOVAUUSWx8tnulytFnQHHZSmd31KzGXS
         0dNhRYdJSJEqHaYhjsnqo8IKfRCrd09D8trIQEN8UcysnfD+eelsEl0M87daWtFuzdpt
         Lbf1b2cMWMb+2+jSjnf8kUz4vu+V46em3HnTiTNXVzQgKSmdZzrtp8Vh/BgYgbL7vIzl
         TehTpoOajq66QhHDpNDmqOlhTdxRkpTSPPppdI5O9brwcMp+TfXcFFjiJgubHeU7+M2z
         kkMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSq9/dvvT5Y62EjkVyZ+jw727aUq/c0kQElxCgajd1QqBHqDQ2tKDSuma1cv3hCgNd7Vuy5vThkw==@kvack.org
X-Gm-Message-State: AOJu0Yzr9J1w30znHo5VluhKETTJOA3HcbmINc7/ufc71ERdOlIOulw0
	ru5Mon+qo2QOocFrx1MtF2fwIPlUqVqXRbCKYnb3p1oHwzuwuF4TcXoSWlN3kjUrsYKqDcWG16v
	vt0IJ4KG02pThxUaLREy802umRgSpDX5wMC/3rLUQVXRTDzq8vgiG
X-Gm-Gg: ASbGnct1WA9QGLd0U6NoM+OZ+NsZubNVdXZw4hNlUz3xZnKi4DcV+3UYgPypZ+Z11Vm
	oP51i3HDrkJjB25OUbuGIqv5mpC13s+ACaGq7sIV1vPDYuAri3SPdkYikno36IjoLf1Cu9Bh/x2
	aB1GrkXwj2D9SFk4va2hYSEpm9gJAyYpG+Tw6MGDx+VokGxFUJ23OIQ8cRNntn4Tz4L/Fq/CSpO
	2Fku6S9gr80RLDQqHs3hKwMEf9t40ijhfu5IGQuT+TEbw/Fkn6oinTH3fLx1HU364tz2O/53Rrg
	xNN7UhthK/EPrc0pbrTyipo5sniR9/pmCgsjGCSNktRgghSyov9ytPNdG7/2oz2lq7s=
X-Received: by 2002:a05:6214:410a:b0:87c:182f:613d with SMTP id 6a1803df08f44-8802f474589mr13457136d6.31.1761859574797;
        Thu, 30 Oct 2025 14:26:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/0JmLlnzB82e3Kk7AsB2jwv+C0PCCh85J25ND88xbRIoJmCyRx94dBKENilCOgrPNbwyPBw==
X-Received: by 2002:a05:6214:410a:b0:87c:182f:613d with SMTP id 6a1803df08f44-8802f474589mr13456686d6.31.1761859574311;
        Thu, 30 Oct 2025 14:26:14 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc4992095sm124571466d6.48.2025.10.30.14.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 14:26:13 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:26:11 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQPX859LbBg5FmE8@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <6odeeo7bgxgq4v6y3jercrriqyreynuelofrw6k6roh7ws5vy2@wyvx7uiztb5y>
MIME-Version: 1.0
In-Reply-To: <6odeeo7bgxgq4v6y3jercrriqyreynuelofrw6k6roh7ws5vy2@wyvx7uiztb5y>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EjbwrAuY7yyuDIH6Uz4oYS8NxwPh3ggux7uT1EnqI3M_1761859575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 44472140007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3nt8topf7wf8jaj8a87nutc7ae8p8wsb
X-HE-Tag: 1761859588-359254
X-HE-Meta: U2FsdGVkX1+USAyl9eIQgNA+F6ZncAdxcXIp7ZQ1boPpvY+Sa8c0TJcmdPpSO12DRmC7W71iGg167IsctbGX49lzU8RmJ9UAHArKATC2IP8XiuPb5ylFKVrMQIYwvaks4XCKgn0tX/kPQ2ytHp2dV2DnP56heyumxmoVA78EIbMesgX2sqyfUCFlnPgVqI5j01OXozvAI2h+A5ncT9D9DPuHvL81ziz4SrmebJngZwZtR5/47if1JmxaJCUuPkmXKVUghl9Ai1aSU1veSsFrTE4e9j3Yn6oUOWcz/XP0vJV273Ybncw7+o/Cgw3L6FxIziBCRVeVWb0w4/hmvakc2F0jbkQ2J5D4LKgtsyf0SN+m5/OuiEzyjcW8OiyjpJG6OhwvuCpI40I95ew2Glegif+offsQQjOhxHAKX5RLLiqxIp2YuDX9Kj6RQxouWJOXI7FGNQpexFjlgbhXvJHII7HH2vmaR3mMiywtf/ic0UnHPnHYnL5VB6fp2aUzddb5il8XGonLk5PY8JYyhb7xWx3JAZqhHBH1yo9jIbqwqCLyS0rVyz+FT5H5JQlD5M0IH7Oua4+jnXQusUjEgEZvTloUPc9u7he5cZ5UKC7+wXM9MZUSv/XgYun8B6/G/KGTIsD6Ja41f3+s0sKDYWy7+cZ7LEvLIUZTcp8p2D5k/foqbKbtwQ79YA3oRhxOg/dRn9VIaw4ryml/toq7l1L/5bYlY88BUt2g9A/kcjWDJhSPpVexuPuECTNGYtdkLa7SYWtzfYOp6fRs54qsS0YE7c5kt9oW8swErwqHCBFpUszeFN+Zht/lgG4PfxAqBuqLziGznIgoZRSnKEdErsjGbjhuBHUQ6xKM+lXVRl6tiLsQR5fLwyjir+LlzMR9RQ0udPUxTTMEB676TffYc3BVpTQMR93Lva7bOiAEHvZmXf6nh2WPdRuGpfPJSJNFgi5EoO3a2DAG5hBZXpFtrk5
 65tuxslm
 jhUGIiDO69QS5mKhPN+InsQuNSaPlOjYrnREDhkJYASA7ZOY8l2K2UMB3mDWa6tVFxBan0CM/MRe5/4Rlkjy+Yy8M7haUQtY84QmiiNGSRqdgHj3lwRJu/FQyzgu+I84QGvuQ8qZa1l7FpE6YR7ayrPvKbnXKcOBZ5wWEDFeH9dXHoWqSNC2fTbTKaQsNMg2Qsi0E6QbOwNSq54vsKFUVvM/MLs2TvSr9m673JV5XuIo1HQspIyLMS7WqlWDYYIF06jm+CeamLLOA4sxfUkG7tEMBZw2SZQdWibpov3zC99eofBuNuqEgjuxW6uqBfdrm1geZWrvFXwJ7fTMBhnfXZY8ZwG262sGsb82LSWvdjtIGVfaIpubXC+vBDfUHsUwIrLYD7Hsz2Dxn6jajUazKMO7fJ1M/g+a7Xsjqha573707jAdrQOgoOrdccrUpGkHaF3D1B7OZu4HfPP7CjnBvvIO1F8/ubOM5YUdjNLa8VT17havZsB1asT2z2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let me reply in short.

On Thu, Oct 30, 2025 at 04:24:46PM -0400, Liam R. Howlett wrote:
> Right, so the existing code a huge mess today and you won't fix
> anything, ever.

IMHO fix is the wrong word.  Cleanup it is.  I agree the current
userfaultfd code isn't extremely easy to follow.

> 
> We currently have a uffd_flags_t that sets wp or not then passes it
> through to set another part of the flag to pass it through again.  This
> is stupid.

I feel like you're applying very strongly personal preference to this piece
of code.  I won't say that is stupid.  Axel introduced it, and I think it's
still an improvement comparing to before.

> 
> And then it gets more stupid.  We then check that flag exactly once for
> the second argument in a global function and NEVER LOOK AT THAT PART
> AGAIN.  So we now have a type to contain a boolean, but we keep passing
> through the uffd_flags_t, so we can see if wp is set or not.
> 
> And you're fine with it.  In fact, let's add another one.  I mean, we
> tried for two but people didn't like two so lets whine and whine and
> whine until people get frustrated and let you push a second one of those
> gems into the code you REFUSED TO MAINTAIN.

What I refuse to maintain?  I don't really follow.

> 
> This is what owning a problem looks like: I removed the uufd_flags_t,
> because it's stupid.  I removed all the hugetlb checks because I
> modularized the memory types.
> 
> I'm happy to address changes, but I'm not happy to accept more
> middleware and "it's not part of the patch set" to address any problem
> as you push more trash into an already horrible code base.
> 
> We need to fix things too.
> 
> So I'm fixing it.

Let's wait for a 2nd opinion on the approaches.

As I said, I'm OK if everyone likes your solution and if I'm the only one
NACKing it.  If we can support guest-memfd finally whoever adds that, it's
not so bad.

-- 
Peter Xu


