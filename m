Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 831B7C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E546B0088; Fri,  7 Aug 2026 12:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0076B008C; Fri,  7 Aug 2026 12:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDC16B0092; Fri,  7 Aug 2026 12:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280996B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:51:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CE2A160124
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:51:01 +0000 (UTC)
X-FDA: 85075063122.24.742BE88
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id AACC6180006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:50:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Y60g2Vo5;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786121459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGCEr55tt7A6Rw8H+48+4baZRURYAlpqZ9tSPUodiYY=;
	b=q1lSEbmILhCKDLcVhda73Ei1MCVnO2JUy0RXEkAIf1gMhXExzq16JE0RSz68efJafapxCJ
	2tR2ZpUzLsgq2WVkoRE+zhEx+JX6yVYyoH8Bx6KKCYi/VyIxJ8D47HW1mZsgeTJFirWaJ4
	GxJkvGZ+f43I3agu9EUisN/4F+95O+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786121459;
	b=jVSggI2FsSNMeStzPZUYB+Oj8YI5BY3/kIos1oOYVN7yJI4crNLcaWlsPQLbdLIh9ePzJ4
	Nxi5rS0i9Y8Er3oRkcTwJoa2OpoAP3kFKrwhZFcuK1mNgquMqrc5hIBxa0VhchAM2x+P6k
	5u9Ir23tSSAfRhTtL25wosPI/9vTi60=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Y60g2Vo5;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5276d598b96so19139911cf.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786121458; x=1786726258; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGCEr55tt7A6Rw8H+48+4baZRURYAlpqZ9tSPUodiYY=;
        b=Y60g2Vo5L+VsVRUvmW9Y2wOB+8fpItFBRVXeJdwUI3u13lXMh/ECezFrj44rkHvWb3
         BQfmrLbdvcnoWKn3ttvsaa5iZGrTUMqIhmYMCqBGGP0ljPR7fIXFTPmYSBsu7gsZq9wb
         48U4Xpku3mteP/qU3yaziEYRl+nU1NjbIOfs5oSSYpg9nJx0Z+j0A4ZbbT7SNE+J24pF
         OiwM6IfhVS/AWwjbFh52f2wC7GdfVz5QhKmuMb3/2jYkL4sr8izt+erWdx3NYxLD1nOf
         29u0c/2ORgSQTnD4KdFM8KIDiOVIBc4kugAvpsusvZuzcSIvO7psJQ1oWDnHstFBJIlH
         mi1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121458; x=1786726258;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGCEr55tt7A6Rw8H+48+4baZRURYAlpqZ9tSPUodiYY=;
        b=AmzTdY1Nh+jOh3h69CQaGdxqA80T8DneYLhD0Gi+KmPCzXDDe1ROapKwCA+iCCKmpo
         WygWrBzDnTMwpJDNMbMJljqBCWS2ewbnbz+QJ7dBi/4xo6BEBXMaX1zA6ly5q7RMIpE7
         Jfj9NkK72TvOI1XZyrBDzFkaFf6eVEfGpQhm2LaYXZs1XkS+i+q94w8np4jZtgsmXqt6
         6piWbvq+2hNEW2fZEn9ZltrohIwRnBnGnPMvgy/n6z8vqWpcy3eRNum3ER/a3KoQh5I5
         8nwluBXHP6yHK8HOKUNDxsf4exPZWAgrDNDqYNxVs5e+mn04Wkv7TDx2ZQaOKfxYiVt7
         gsGw==
X-Forwarded-Encrypted: i=1; AHgh+RpI7rpDYZ3JWsO5zCJB7OnOLF8De37CIzEjA+CPXyys3HJUydjHFX771jXRxJpbBE4acpStKxxjvA==@kvack.org
X-Gm-Message-State: AOJu0YzrE38mEI09uBqEotkulAcRyEsaAtgeJAcfW3k3Fz5aKo8YlUZM
	msyagEc+2R1UhqPZlpZh6ijIGUo6cQtJ0gy+5uTUFUcnFp3XkHc72g/EDjX59kv2z0s=
X-Gm-Gg: AR+sD10fcvuf5QayvQQvnY8P1nUnQln7vMeTkNdco9fTBfJ+X2XqAFwsD5WM1n3GqXu
	3C7y1YBYc2OIfRUzryPxR0LRTcZvh3egACkn8RJMIVjFhS7EerssRbvFhvjJ51XtKVF6Aoh8Zcf
	77/BQp+AKU9+3L+osqkKSWe5yXQCoc+tDHsP+f/nEggM+Ybn81rICmJIw9E+pyqVHk1UkSFXw4n
	MaZRc9KIPzkbPSwZHWJd6+lcT1fQ+QtH96of1RSqh6wvtkPOmwem5ojGEpdfvKEzbO3vzKktsVf
	6CpVNSqqPxbKai6VQLrMke4lntf04ps/ympOjNFGaXiKC6WV08g+nT891fzhqYOFYqAbg3WfY6L
	SFoRlCl1si42VF1WC551mW22PaJCW2pA47PKxSm1Qp1tZ7tGLhpwkpI/ijq566DBtnBDVlG/yN6
	/+IdsMf8klpu3LLhY7m0Fv8hQR9aAbMzZSXh/SSHbkKdngth2P3An+uD9YPRDC
X-Received: by 2002:a05:622a:2615:b0:51c:f3:34d9 with SMTP id d75a77b69052e-52ce6147282mr289645681cf.27.1786121458608;
        Fri, 07 Aug 2026 09:50:58 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d165a09d0sm15681681cf.17.2026.08.07.09.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:50:55 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:50:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: remove PageReclaim
Message-ID: <anYM73TFvNx5qEpv@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
X-Rspamd-Queue-Id: AACC6180006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: j5g8x5zcnwdybof679yewsf7j5r3b998
X-HE-Tag: 1786121459-916155
X-HE-Meta: U2FsdGVkX1+SQzrez+YTioLd1TavM07dXtgi7JbHEECu7GdhscT6fGsdgfHTmXOziBbeJvFnr69qjg3w9ZK0Q0dktijKOMHW6gbTL3rnEBQBhKbb9xM5zGcOo84GrnrQXU/QbeeXyGLkGXVTE8pKmqN2OFkIlpbTRGR+VFa1ehIeh6m8ilu/Wgja5g1gFBtsXGpZKPTilh0QcF16BT5Bnpk5SIJbKjnS6xQ91A7AE6B9OqIYMSUMgF09AnQ091SX2576XD+Yo9qPKD5PhBpWjyiWwY01TFun+gENt5dzkdOgWZ2Rs785lqsW59hKcmnVtmlc6p9ZV7LOQL8GcGgjqDF0rRvBXDIudOVBZppyEt2wO5oRHryQu82FT5wD+1oCxW2+ksN58rKOeSIMocLa31z3fvULwsd33tLctx6pPqmho+OoPJnIiTfFQ/7xriWJoZyE8Wf1akZ7yomH/Ci2wHMCxBiggY53ADCMuV5W+MXNMZRk+69yGrp0VBnNRg4slExZt8wuKQlPx8E87KzRDVsGOzRtZFaB9JWxhy1OJCRn6Je0UiW8gYsTpsAyqcmM8kAMDTzL7oEmBN1mOdNWMZOUod1LrDtLq843meP/0SLz7LpVB15cwcj9nSPtRcDEyf0VaTACioii/PGsUxadns5bN8tAW4WpauSOv6eND8FnjjoAzi2NzhU1VppeCg12Zh6a/qWek7FKZD9ufhT4mcZlECbPylmC+bUF+zktj1WU3DowMPjKlGBOYnwxCcRaTbP0fGMWaf6qdfIFaa9qnsvl1dQhTJO5IwJEFDfOAB64+wybBrvxiBZRaZjcJGf+n2uHYKmrfMiRLN7v/BcJZSrKjoy/x1TP3B4OUtGWbMqorFw9WY8p3/t2e6/oT1AdptSBx/t94ene3kOrmYRbJbOmcdNvVpkSBAZyc4qlZapbOnY2lyEJ49R16AY3LqO7XAdVJWzXxTgv/m/77Me
 hqDVJUCq
 mv2+NOdXBmMbBwllE4RCirCnArHy2EgbEWtrEPWEguZ7afZsoz3+Xz7MvJUiqHLo1W9t6jCIM1JejhlYB201qyT1WPBWWMTC6cancI4zvs3sAMS2qL3W1McSy3Mdm3qPVs2qOQ2nGLKsQByjD4T68RBZif6nA86A+P497+0CBy8SCs0jvK7zoEtE93/u7JXLsC5lWEprS0eF5uJDHVl3eNd86+9jVfULO4ksomDvKvWVPI9HmabRtG/fzWrc3PJepcDXeDcbOPXkqSOH341FFEHW4yp5rwIz19SB4kV+OWPlTnuojVrXoYTuJJb/yo78mVylNcb3Jvp5hzNkWmwh38XsKA+QK3NMl3CVwjm1GZ8V6sCLHh82NduQdU29Xk9tUc+0orBsjT2JWerzfMn5MPvMCNoIxARR4d3sO885XPIqaytcLaelnZHCjElP/+hBr/mjQ9aH9fEnMiT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:34PM -0400, Tal Zussman wrote:
> This flag is now only used on folios, so we can remove all the page
> accessors.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

