Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C901606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xzdrztU1
Received: by kanga.kvack.org (Postfix)
	id 532B86B05C0; Tue, 17 Nov 2026 05:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A376B05C1; Tue, 17 Nov 2026 05:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420186B05C2; Tue, 17 Nov 2026 05:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 138346B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:06:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 759FD1603A5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:06:25 +0000 (UTC)
X-FDA: 85444181130.05.CCE61E7
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id A63A720009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:06:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xzdrztU1;
	spf=pass (imf31.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909983;
	b=VsonqTR88Jkmfoi76DrB4zHEP8xqt9f7uB5u6CO/HoTn/w2vsy1JaIttFOQnoFdBV0oYoX
	z1N0Bxuwx28Y6ams4ETyDD7UqsFTCL7C22hvYUdPi96n+8miZvNmwNaD6Cq4rPhPMcR144
	bs2AvgZdZ5/WdfV5xCUottsKZo3X8gU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xzdrztU1;
	spf=pass (imf31.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rI4LasV5b++IgM0KeqrCTlvPABydB8GrsEj8qvf7nig=;
	b=wiZBoPdMwXdEA3mCygKb7PBH+GStewMhO93sFrw2KrzyeNN89Tl0kGTdMrU/1IEJusOe0J
	Ge1uPkQ2d2ODKnXM+oQ1IWTyHifx4Iq8C/U180dQUG+G26KvtLUzdj42cj4JLI1h6zKsg/
	SZP++9dmi0fhnnL5nEn2koYqN9dzs4o=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so3721156b3a.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794909982; x=1795514782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rI4LasV5b++IgM0KeqrCTlvPABydB8GrsEj8qvf7nig=;
        b=xzdrztU1LtjVFhCPdmuw9+W277MYKWzDR38c/H+KGIMTBqXPNwcTX+xFsRqqN478rh
         f1AbQdyNHv/Zb+nanrv0vrFNPLv05W7ELmujM517xA40Xhe88PVeYv4CEZ3PCm6vrJ75
         +GivlplFSvviYgf0zsZGsRqWySEGWacecGKEESQ0axYbIjmnYi5k41OFTRZ+wS8uPkr7
         IYtdQ6lRDqHonzE5V/VDVLIYo8OmQSsJMzhy0qcj/RSjXdL6rehIEVFKyQAt8oYD86+/
         cTzNkL6jKy5zK7fb88YVBG5Q4Wd8wuJ9ZomKqkwlTcYpykTJdsP0GtT/cNz9GBcMR36r
         igNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794909982; x=1795514782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rI4LasV5b++IgM0KeqrCTlvPABydB8GrsEj8qvf7nig=;
        b=ZMfvnDuwc/SLPyFeUQS48tIsO/wEQPdlcuZQg8Po2wd4uEn0jIVhkMRY9NHQJBsiTa
         CQcJSOXQIN1CnKbmSGX6Kqy5xwT9sD3ROY5XRTiN6kXG0+wUf2Jh4/OlhmvgaL37aTrf
         LVVdA78MtVhjQlud9F5i5NCn4ezGRrhpnxw0THEPO1vCWhsfEttNE9Lpc5sPjGlxtQUD
         Ib4fTA6n7r6bduQdjle3v2Bel0uxNvpICsFc9bJzR5dlX3ZUiXCk8TqWeDerrndKtopy
         iWLx7URbJBUU59lofHs+s+tgulwFl4xq7Jh7pom7hNqMbEYhEgRKWyovruc/rvrN1yys
         Z4ZA==
X-Forwarded-Encrypted: i=1; AL+hErFo5yrCgIv2eKjEJrStwip/sfyzhU38ZYR+1SO3bxXhBRZFFqwBDF9jJ9yry6jVTcjRCje9DdTJwA==@kvack.org
X-Gm-Message-State: APuU4Z8W6+DRLdl6JAH8k9Fqmi0c68WjAiSItF8euJqI6BuzmusR3DVe
	gqnJw9Qrooafn4SKgrcMDj94ZdyaNpb3jwOWYXQ2uRlTi8VsddNnYjOw
X-Gm-Gg: AYBFou3qWG0N8KpCPyvxIaZ1NQ1bculX5iTWyn5TKuiYZxX6AoV8DCzrcfvI821G8zA
	P8NipqVEiA+DWWsRmNISVNCENT9R7DrtyL5g6GkUiUGnylb0pPNBm2BCWPtywRxYbujabmzF2zt
	BFbqY6aMf0JpFYvNAvmQxlI4aXQea/Ac5T1lyvRsGQff6qqOej34NSzHW2Jtd7OapSaR+QJoqCC
	HRajA+a4FuEpKtXQRM4SI71rAk1FLRyaRm7CPbHB4vuMW6lmjddm1u43r7k6MlRk77sK/nGJCsn
	D9NIz0uKKBTIjbOyFHRVDFaUTwhVFuHyPHpEac7kevjMbAdO4nzad07niUZpjaHY4bhD80jjY9t
	2Ulv0mpx8t4+V3e5ECPN6SE7jsE8d9eRh61UcOe7Qc8Jhcoov5TlZ6aiprJsY1L/7S/a/RuMizc
	jevm3tSy3dWJJApholl3HUrZey7mYbFJ7qfx1Lz+tZRbMTDLr9JajZy+yi4ff6oseheBszeDQCa
	2OX0BxXW55kBjpscQ9MP4ez2IKmcpYkqqosEfe3YyNfUxJdPEmMT/5gINfEjPlYLUdcdoN6sxC6
	8kEwJRHuOTPTkJkoMH6BXn1mnBhsEhF9QmAnQWfYVOL7chBgVFMsWpx5C8FviMCo/m4WVoiWXom
	EhO79Xp5CXwIVDu8Jk2uyitMMg+dJBp6KUOEIUxlKmjM387RuqvesWDH7YIwSj9DqXkZnNIQGsP
	lfSHr9pdZ0JSJWh127SUHoFjxWcCGVrJgjbi/BDahKj+PK3lAl7fFHjzJrCwiuNV7JKHtQ7VFQy
	W3HBu/I0LgTHiumCKMH+aF/1jM8zlVn0mxiwhOEhgo28Ai5IpAwwFMGhRDA3p8H
X-Received: by 2002:aa7:9ec2:0:b0:8bf:e028:7864 with SMTP id d2e1a72fcca58-8bfe02879c7mr6741005b3a.0.1794909982190;
        Tue, 17 Nov 2026 02:06:22 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed263b354sm4752612b3a.47.2026.11.17.02.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:06:21 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory: mark unshare copies dirty to fix MADV_FREE data loss
Date: Tue, 17 Nov 2026 20:36:02 +1030
Message-Id: <20261117100602.797-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <c7c8ba0f-49ff-4b22-bd24-20fc394b1e36@kernel.org>
References: <c7c8ba0f-49ff-4b22-bd24-20fc394b1e36@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3f813kgh1fa8yoab39gb1a1y8yqwt56q
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A63A720009
X-HE-Tag: 1794909983-248761
X-HE-Meta: U2FsdGVkX1/HlS6LqGQqVFrcyZYCv6Sw7HQqXvKhad2vYDGC/jH/mrFDMB4IpmM3fvXURh9z97IowpX3NWKcw5p7veDu3WKwypH1IwYmrKYMFltdMuMFWjxeQ9Yp0djeJt+IAdAe9dQWDv9t4/C+40/e3+RmGVB7EmU5kdJVVC4mdlPIf91Zz0kLnXqkETfXAbjBqCwNy1MoG853RDVEVPh0OfUbta5nR9kgcI+IvPqnisQU2VuHGk1X5iSPwhQgltI7EpItWAP2qAolu3tcW95agjaDpuye5U9s6z46EmLw8YNbVhFaSLiRePZcHG42lXfN/z9YN0fbRnl1yy0ox3o4n9yZxAkZZlaysMiDc/M6lYf8SEyN79t7mLde28yWk9EWC9vfA9jH+dbRHUI9DWNinFawe4lMRBvFb4fuBChLCjB30S1jjYFoSLCsxfFr4QvNB2DEZaspubhl8gIHNu7UHNHu3wxedKSwbrYXTW7ChQ2oPigxXtUB87whh1xh136RzJC4kNpxrYVU+hPhbCvGDL4pGfCIbf9YZtdqHHVIMhPXkrWmStGa6M3kdXBOOfIAJZ/fC9mT55vmM4fZ7Cxb9rSqxGXCSn2Aen8865f24dyg+tmsy5w2gbDF8Im1//VDLsp2L4IX5g70YqQYnlvoiTiZjUYycOPLK9jBSJ8g7o55wVwdSDAMzhewqsWge09peDB7O3YyjYlEGgVPbnD/Pu2jBjMvY7xTmeUkiVFkO6ogFrD+xSQuT3fdmVxLTFcO8oq/Bg169f8vtSY3wLJuoxk9TojMJz+7pdBw8jZgDFMSXoM5Jn4AUYeQgPaG+8Uj8GR+4cSTdqibh4xpOd4BDoXAN56CXfndfKHXf5QMLB+t1REtH4qpmAqRKcb7f+w+7PdOjbr+CXLCvpta5GuQVp7Q3l31tYNQcDMsQq0MXyTBDdRsHHhpWXLvBEfy+PMnH4IZaqjoiLYc5E8
 gFr2LZzw
 O/HD9+f3sAwh9l33ePS0mt5rHZUEha6ucDxpy8mkDaV3g1X77kQpfYqX+6wnK8hTe2uFmNe2CorYrr543IQK6KY91vFzsgZSaq9vV6gT8iB0FaFcQkTkCQKw5GpDugM2B6tAon3lnjJ+9hc/rcyDE2sCz7pq+3bCENeWV1ssYBKoqNW0SiB/8phc1KWtIftSWLQkXkhFVF3Xzvqym2A9H9uJ/XH1+pXDXFjLB81puY6yIVfHM7gtZbRnmivHMLYCwVVzVe3AtQ6TcfQ8wbQNInyJHGieVJa0O+HolYn4bDqmDokOUMJSuKMlhXhvD4wjnzRHYkQrzpVy003k6XaHgygHzy115Pu1FWe9wF6LHqQbeWf+KeMMgafNIXAH2asL7LydXS0wEqjdXxIMpkpSBCU6HACCuXHjcLJjn1vhdKIXSCHA3DDJ+WfTt0exZ7Xeb7wiTwC/jnlKNaXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 09:55:24 +0100
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> We should always prefer setting the pte dirty, not the folio, as the latter
> needs atomics.

Will do a v2 with your version, thanks.

> numa_maps does not show any such data. Did you mean smaps_rollup ?

It does, gather_stats() ors the pte bit with folio_test_dirty(). So I
kept it.

> A more future proof solution would be to only allow MADV_FREE if we are the
> exclusive folio owner, checked under folio lock.

Makes sense to me, it kills the whole class instead of one producer at a
time.

One thing though, that takes the folio lock on every folio. Right now a
clean exclusive one doesn't take it at all. If the lock is busy you skip
the folio, so jemalloc freeing a big range would leave some of it
behind.

