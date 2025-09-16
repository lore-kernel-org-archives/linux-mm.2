Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D40ECAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5126A8E000B; Tue, 16 Sep 2025 18:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAA78E0001; Tue, 16 Sep 2025 18:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFC18E000B; Tue, 16 Sep 2025 18:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5CF8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:51:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C178014031D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:51:46 +0000 (UTC)
X-FDA: 83896612212.24.515638D
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1DA1100008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:51:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8+VQ+15;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758063104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahw98Nzw0N10giaerVDfZYUU4ISliFAGxR+jojkghBY=;
	b=4f49eTDTaMZddRw+BhkDVOxDdnixjAHIkn970y4l2Q1GLZlscVOtFmqV+yKojq0MGWzc6J
	Z5tsy6F/hnw0huz5JQpCzRNkbszXL9VQ8jhhO33HvJIL7kPiWUxjnTX1dubzv9NCi4dlB8
	2y5iM6I5Lxk+ZhnApmMlWq1EKXa45Fc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758063104; a=rsa-sha256;
	cv=none;
	b=WxPHpJFFBdHNNy61iQcqutJpQAM3Gc9jJb9N1nqkHRxzY0AGYqDtq8y66D0QPmrB9XeIN1
	J3d5yPgR90DvJ/UbYvk+NfeI+0PXRsdWtfsa8S/7ovgwY+jsNPMSBkoiS0E1cRXfDomtm/
	vI9wolpEVRUa3vu9w2G6QMXzLTqBURs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8+VQ+15;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-826fe3b3e2cso331736385a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758063103; x=1758667903; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahw98Nzw0N10giaerVDfZYUU4ISliFAGxR+jojkghBY=;
        b=N8+VQ+15B0ediSWOEazwestyzw7+pPM70ONf5wm+OlkLmsNlsgeA27bLNYeg1W4ARz
         joD+fNp08Ot7ThjBEmFOA9w9RoUwT2+rTcDH92ix+rol0DmEYLfv5n8lVubUJgwLjH0R
         lGkGS6aA0MV8fWdb2TsBFfzI87AJfLQhhiIRe1yCcC6/VGuyaMepJI9QdRHgF/FYDEco
         Q9J8EgHJ5hjGGN0AASNLHjbGGZY7oak4bxRyy1tiI3WqS6Q8NaxB5q4+gvyAnDRF0Da2
         +sT4IRcbFz4H5CfxUGodTpBjk8o6FZBoGhZ3xIKaDBWSMStsFl4zlCB8wIFdvh02tFxZ
         MxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758063103; x=1758667903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahw98Nzw0N10giaerVDfZYUU4ISliFAGxR+jojkghBY=;
        b=m2PZ7XJzIyKCV5tYzQdDd17eiRru2gBZvS1fxMjkHSLFbqSe++CDRYCBbb/VB/kTl2
         y9KDfjh2+vjBae2ZtTKs3ce9BjcKgoy+u0KadAxz9Oieji3W8XPDen+W3W/aWeKW2HJ7
         JSFdvxXC4ugNakM3XrnbwTxqQKAyhcuOw5kYkeIWwuVtw04rEK+VSxwjlAKdg87rFxu2
         CSgjuGfs0z5WeiYQ+X4MmmbIIP1KCjjUd/rusJPISpycgTs0YSXU+rkriauQeFSnHmU1
         m5HW+PgkRvhEYFp7on/mljYdgn0Kc/IwREgeGknl+LbDmtrAVofTk7KUey+5N+gx2d4A
         h+Fg==
X-Gm-Message-State: AOJu0Yw4ddMrZk56ybcfaE+PeZu6j/BD9r+tLhIezJCwLfg0COGuMOob
	ht0wonIvei072Pbh5aHKObK3dTpB8CuLRAS0Q3dx80MJ+1rdElAg+9u7YIa3M5ErpDpYix5evnl
	y1UMmCCnB8If2Yuq8zcZ5AciSB7gXA3E=
X-Gm-Gg: ASbGncteP3p6FN/MMEyo/uG+mgBqqz+KyT2PNYz3sHvUYRhzyt3s+RH+rBQsS30uMBE
	DL3Wl9VDQOlhQf7ykkweEgfvtZ2eoIDarWzb42NFucEIApAIGKXmxzZObVcLWFYUnZogdm11Rqi
	YLr4/gFJbSUbD5iKtsBtA2BxsPGDn2wGCgyVeUxHUTPdXNZDOqN24BH1KNFC46TRJK8h6cpvRHo
	b5vmI5fAR38ZyF3rnlP/wCmTbVhwhX11uIcvP8Q9w==
X-Google-Smtp-Source: AGHT+IHDV7nD5StKN6sQ0CCv8Pll6eDmsLAx6Ma2rmFxhhZKYW073aqO6y2qoI68tKM7j1GcUSZfrJArFRuoSxelen8=
X-Received: by 2002:a05:620a:44d6:b0:802:6dc6:4f32 with SMTP id
 af79cd13be357-83111e2ba84mr3202785a.78.1758063102916; Tue, 16 Sep 2025
 15:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-15-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-15-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 06:51:31 +0800
X-Gm-Features: AS18NWAfmfKuo01K9eBS5msm-CTFs3neeIOqnHmUZFmjcxuaQnHLx8ZLGuoqfLE
Message-ID: <CAGsJ_4zuLQeCDw8=O-bjxg2uaiq3wowa_5ZXyTGjeS7wGnrUgw@mail.gmail.com>
Subject: Re: [PATCH v4 14/15] mm, swap: implement dynamic allocation of swap table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1DA1100008
X-Stat-Signature: h6d6ejigubc6o1ykoe3kzjypefmrqhjb
X-Rspam-User: 
X-HE-Tag: 1758063103-255134
X-HE-Meta: U2FsdGVkX18EseoOiREy+dsgACkUObg4UNVulYgy5CmAxuHPQsw1OLTe/jCIUhZFlgh/bqnaBx/FNCPQkpC9Rf3QdoqBC8PNfdlSvnVKnrimumEB5GHxnbsf7iFdqI/Z6Xz2EXfasOw/snn5vhfolN0Z+9PVwQjgdseV6Zxz2vUshfr9bsLGb5Zt+5kqJ3EQ3T8FyyrJ4KpIF70Vqe/ARoOoYvZT/QsyphAF0vPp1gSR3/CL/iVUn7chS3g6DsFMDDDprlMaanxpTcWjs1ANw3R81xCpHsRjlB8ufeGSVjN6iuHQStXJvo+0y5TWId3e84041E3Wg5iHVebqJM9GFkeE6NMlMSSE48pMcC2DSkeI/LvXxE40iEf4oXQwPnHgwdQnSwUfG9FOkXXE9JdHJqP5RHJnSzUa4glUx9gvHtDOA2VPHvT89B9ppOGYKk0Dby8Am8H47ZwpZonDRoKC1siN7Sc7KfsZ7/WxrCD4+mObLZHraGdaeSB08GkTSu2mq+tNksXEl21W/CT+bfsSuSfXvEJXYHzR1NT1U8NkOH3I6s3j8bQS6/hx0Yq1a3Xb4+RGU8yht6kg0qyUlSPCAH4hOKEasdyMA5AwxFqTbtYjNNWn4orYy9VSQX5foDBkKfc5e0KlWvfcJIsoqZP8YttIJZ9AYUoCpPf/S+UYRHlZdgpSqKoaeIzJnGWwSn7T2lwCoM5BuJm3fyriieqkrGIFmlGS5qKfnPOELI644vGDNKzJUOhl+yljVrxS7PqvE7OUvJ4SlwGmfC2+c+XXGfYEt0vcfjUjFlRc4vzqJeGlQFqPDjAn34Aum+aNO136R2JKT4fwAj9XBDk9jgvaXla9tO7IMnZbLA9Vlp9qhEg8iBdijKSW+Nl3FYFoPSZKluykyF5wiQkRA/sVpQk+48EMRugY66DTIPIlkpgFbzmclUI9JvKW2vKIZ3/wQ6A0A5oAbAygz1NRVyqdGrm
 Zz3el4Wg
 ByKxrAx8jm+aMuhWZUUrGAh0Auo3JChCMiflG4bNWs/wkq38xKMnHOPhlQuTJVTsrREBic8udsOkWD9JeAhdCT8U4xbalQVTC5OlGTbFumxhMR72JRx9q/0nDRlpbWUMIR8B6hbPqaqP1A3LBK7SYI2a1qmL2AV5PHuzcmWitq07YLoBsTfw7+wWpjUOuXQzqoUnnXnfoqhl8GxrqgShFUcU+CCRJmTxhpiTYQkZ8chMjlK6UJxHCf1JP6JdQPrzoiGWijvOdAIReDfWBFZ667uslX2AqWwszSAwQ9t58weCIfj3ZN34VczQ/8/ba8xRBCBGdJF8eO+WDhEeq5plkOR6hGQh8lE3eZ6rvNfBdGQpmD8xq787KjPj+MC7kh90OGTxFV+/8SRD1VkLCrnX40hW9stNMIJzEi30Wn0yDPdHhXCI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now swap table is cluster based, which means free clusters can free its
> table since no one should modify it.
>
> There could be speculative readers, like swap cache look up, protect
> them by making them RCU protected. All swap table should be filled with
> null entries before free, so such readers will either see a NULL pointer
> or a null filled table being lazy freed.
>
> On allocation, allocate the table when a cluster is used by any order.
>
> This way, we can reduce the memory usage of large swap device
> significantly.
>
> This idea to dynamically release unused swap cluster data was initially
> suggested by Chris Li while proposing the cluster swap allocator and
> it suits the swap table idea very well.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

