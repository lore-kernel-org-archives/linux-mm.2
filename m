Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EFB606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a4IeHr+5
Received: by kanga.kvack.org (Postfix)
	id 81F9A6B05B9; Tue, 17 Nov 2026 11:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6926B05BA; Tue, 17 Nov 2026 11:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C406B05BC; Tue, 17 Nov 2026 11:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E08C6B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:09:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBEF5A04AB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:09:56 +0000 (UTC)
X-FDA: 85445097192.14.5AAC39A
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 19DD720009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:09:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a4IeHr+5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nakixii@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
	b=fuod2OYVsfXZvRYG3Qf3wYYyJ66bRmzp48vz5GHeW8GU9tcSvGE8zqy125vQuE2sOfkCid
	rpt3nKSJwNOVw9hxCVO9emjQxnQnjXgwSo3QFKYGMypUaQ3jzrK5/z4EV226iDonWRZ/oa
	/t1TFYDo2ALvaIg7+0wmOgNtd8U7u9Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931795;
	b=ouNoWN4C7EwpbV0Mpa+hZVj/RWOE0s5yLTR7NzxL/MiM3lI4mgEVZ2jlF2+IJa3xFVzb7P
	Eo5RBeeIZr+MiVKkj+fibdCOAw40PeRrKTNOAEpVFTxF16KRl+T+DVLUzVscuKP7+PJ0Ww
	AXZzA6js/08K4woYhW8oB1Dbc92kyYU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a4IeHr+5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nakixii@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=nakixii@gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so16003a12.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794931794; x=1795536594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
        b=a4IeHr+51gsW1Fl/8s5zM06v2n/5SxZ8iFniAbsNfvmjt1Q2TatQCHxhY97716DRNy
         YFBq+PY36pw9jgaODbferJ8WpmuUG1y3FQ0VeHbIxZbqR/CweAHC2gWhzhgqdyUY7F5b
         YKd8PO5xCgd6q1LQmb+XWNR3YZALuS8kpyjwpuOkzCEvcOMiKYkYKFPiDm+F67pXcSlj
         ohgBAAjaQaI2BEmkHm6AXeqJXUueRdNGEz3+vyo/NGGNvrIVBUQrys9N5OOL6fhiNCEu
         JqpmlV5Si1HemEv6/zL4uPkwy2Xjv5zJniOUxRpAU6Ckl+7zs7oTPQrUyLVCaRwG3R2y
         0GMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931794; x=1795536594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
        b=hsxsgyDgewGDi8rHNOuGy9jLfHiyOaXL94cyFD8En5N1kml0iGbUyBrrh0DCHjvIhf
         FT2Sy3Y0VTynmLdGTCZnH247AUsh2x4E13zkkqF3WSJMkuiGQoaeCJoqdy2vF697ECr6
         U6dFhADxBJ2Qk+WIVAbuNEnwyBzQ7J1q7SMOsTlVxsKB9/4LHop4hvTOmnxeqqxV7G+G
         lmzy/5C4OLRP7nf7N8trKMsT/c1Je7/wg9c2Zdtnh/wJ7jDOTktQXdxVJnL6OpzQh2Ez
         yxiU3X+sDBtKpTCwWwXDr39ps1dj6+DSDqAi/kEUufmP7a/sr2/y87QK39H5ECqi737n
         iTcw==
X-Gm-Message-State: APuU4Z+I+oFiBfkUX5tZivB6O1sSqE85AE5QFQFjh3uGKYoEwGTVVEFo
	dzrZmsE4Az3QYXgr1g7hDKNhx8AiYl80DNKdXNIGopoDKzN7I/QV8VL0
X-Gm-Gg: AZFdTZdldUppBGdwcJvF+9+zR+r70iFBK8R6UF/5TIemGeRzLVaIqJesjEw1x/55LUE
	ylDbea08D8/rmjaK2OfZRwvOvNxEikmpXGYsOn1IFUuN9CA1Iz97FNBX/dGIrN5uiLMXcPSAUGB
	PNwdsITSJEXQEJrzTYBbpLaBgMlRZspggaTVt8UE7x3c+OEzM04nB8UsVBpDmctyAYDukzX/Y+Z
	czS3ocYm6hLqIQpYEzB5izf/3b/xhih69zbWNrp7AKyA+0apBxczzd/yX+cusmzV42lnVpht8dS
	w07+PsMbfXcRjHHIvgEgFk2LDvFWuGsrSuTITtPlOS5zHtFQWao9TNcUgqQlHnbzfMC+DrQGUTB
	yGsbIZXoQuEBBt5Zv6mj44MM0tj32B4Ubj2K4rzQ71ZfaXXArZ2VoAsFNskXKVm8QokHH+jutiD
	HKnfQLQVjW+3qifrAHh9CltBLGCBaWZmTGB5KU4pmQiDDZkLITK/wyw3S40Phia7Wn9pEFplMCM
	Lg3lemeoXRykCb+iqADbDF8R5qA28Uc8aGvtHMluHnJikfT5KDArC6Jl6+ZwQ2fktqwhs8cqY6B
	y6FA7Ly9ONG4rm2qlQ==
X-Received: by 2002:a17:903:32c7:b0:2ef:dc42:10b1 with SMTP id d9443c01a7336-2efdc421364mr28930395ad.49.1794931793688;
        Tue, 17 Nov 2026 08:09:53 -0800 (PST)
Received: from naki-PC.localdomain ([2001:df0:a640:2::19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff61162c2sm127965ad.12.2026.11.17.08.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 08:09:52 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 00:07:39 +0800
Message-ID: <20261117160739.475062-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avrliOfBi326au6B@kernel.org>
References: <avrliOfBi326au6B@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19DD720009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: bwfmirihdwfh34rnkfhpj1hq86cwx1uy
X-Rspam-User: 
X-HE-Tag: 1794931794-607976
X-HE-Meta: U2FsdGVkX18T3VK5dEK/QsR99qfSBd9I+rvLzXsYoHOI3YEcsEh9xq0wK5LrSqYTY/oWNl9ph1E9h+tHhd4/UR6cL65DqK1+aDKegbEBMhLqWK0aQ9jMsKdMVupIzb/q+uk2Hbu0joyZW4e/sjMt/YjPdRHPsk9mTLV46UWVTNz/5UKjwFkjnEIP98hyqyMCNnX4myTtdYFv+rJTx8M4D4I+UreCTHsEPFQKswWdfl3pZtoix5TWk6D0zluIIpWs6wjjJCS6AVckamw6Nbjznigq2hukzP4itccAcyYGpGWg25WyfPMWsdmGC7O7ZbqTlxpxudUPfdOo+CEePvFyv649jcdD6POLOjpHiagyIlmbidox9SUntAMr8bw3XTXGhmEmp9w/jLDs07obTTlRCYFQoDQYCo6dQ/oc+WHWiXEOW16CfzxhFWhmG2XDdczjOK8xKrMP88Hx01a3GQH1HaTjK0EsZ0aQ4jR3BSbuScvci9AxSKRYKJDCZ1XT3feWK2nkSslcSTDk+v0Qy7ZRUGQKhYfIWHJZXG5RZglkdyIAC5W8j4D8eb08s0AYPzmzFjvKEv7d7aXzathsIkn3P7FKeQHbWghULTNRZWv7ekA+m7mF7A8ZKb/qIrUdCFNGnH1oMgWGt/5qbMQeY8PCSoeUkii2rX/6dnXW8SG+xB0YtFDhfr0MabBc4kvQm1UB4j7QyfQ4WwVQltfIRlY7Tq7ueZGP8ZUFaAdyzJhKTAd0RBFWJhv8jvIiNdl/xpcyh1oeAHRkzgre87cKj0g1lYqjHMHLHPzC5MhEIs4QfVJWcQLDlqtAPtQBzOeVix2Fe5QywkJNu4ML9AtyHoPa8gagNx50gtrb4o48B2Uzj3BzJCEeGKLMliLSXgE07v5b6Vwbx4LWTzvEY0wCr/oOL1zzmHL+0Gci1moqFTaJdBgM3BYRbrFBj4j8PBpJkuba/MRtqqCMCuteXfHwIdN
 /9F9nHUE
 V68WSxYCcHIcRJZFUxAeHhOGUUdD5kqS0qf+n0CATJlF5znxW+aRiFzKaM1HuCLDDZtUL1E/x/EOW9dPwtA95zu1YpkF4eoU5PEJjkf6nK9TaoMQEr2oozfxwVCnbWYue3sVFXl4DTON3F3Nk7alhVU2oJxfo+JXD2zHn+jbieDIDFh6utjUCIcs9iVY0RwelbuTiNe8O4RRFL/vxh+DIZJ7eDZ3uhO2TjSP1sYAZOHLwo7j2rQenVTpcS3Uos++7qtk/w/QzUnkuqtct+YbzkLxU77tjMxIqxzYmPlgGRNV/Fe/fC6l1wYr/azFQSfh7UN3W6enjRyC6+DgRZg9j0UAIbhqTOe5qegYYc2TWaSR3YGBs6Ze8E9zbuhQFU2H8DTDNxfy70Qdx/ICPRmY8Q7MQKCmqhj9h1GnqekalCOD8ZKCjG06ETXlFDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 01:14:16PM +0200, Mike Rapoport wrote:
> This seems to big of a change and the wall of text in your "results"
> section does not explain clearly why would we want to bother reading this.

Fair enough. Looking at it again, most of what the series does is
already covered, or about to be, by zswap and Nhat's virtual swap
work, so it doesn't justify a new subsystem of this size.

What still looks interesting to me is a couple of backend mechanisms,
e.g. packing several compressed objects into one swap slot on
writeback. I'll evaluate those on top of zswap/virtual swap and come
back with something much smaller.

Thanks,
nakixii

