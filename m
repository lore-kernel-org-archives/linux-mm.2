Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04C1606A323
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.cmu.edu header.i=@cs.cmu.edu header.a=rsa-sha256 header.s=google-2021 header.b=dxZ4mcO6
Received: by kanga.kvack.org (Postfix)
	id CA9E16B05B2; Fri, 27 Nov 2026 20:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A186B05B5; Fri, 27 Nov 2026 20:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBB76B05B8; Fri, 27 Nov 2026 20:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5A86B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:10:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E35AE140241
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:10:25 +0000 (UTC)
X-FDA: 85482747210.17.9D5FD87
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC72DA0011
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:10:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cs.cmu.edu header.s=google-2021 header.b=dxZ4mcO6;
	spf=pass (imf25.hostedemail.com: domain of jaharkes@andrew.cmu.edu designates 209.85.160.181 as permitted sender) smtp.mailfrom=jaharkes@andrew.cmu.edu;
	dmarc=pass (policy=none) header.from=cs.cmu.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795828224;
	b=LnvKSLlJJwsdianIQ0GiHe+Y58eEtDoaf2Gzd5k3vbkASUpOLKOLf2IBu4rGzEUw5V9iPA
	TmDU2tTI5G96Y7+qDQ6iyVFTYFbS83ZU+8zGgETZI8hBSeuJUchtpELuV9bgWmliwG1j6p
	OPYxSH5i1lmpMCV76fWTPlIUwIfBArQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795828224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCoNBWE3kmGZQJ1kgw8zMrA5EDN0aulmwFxsRmULwsM=;
	b=TqNUlGc+9fl/ucCANzAQScQa/YPLDRPgik3CfD8nNJfNWg1Oz4F54olaem78UJNSp/bnqO
	A8VNVyW3pNNmXOHWXWVVQA6tjE3VU1RX5QlQ1J+dQ5p2kq43/xLR0fi5f9PEYOiWyiHXSJ
	KtyWO1+ToIx1iDrZkAgoWtIl/Q5UQ/k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cs.cmu.edu header.s=google-2021 header.b=dxZ4mcO6;
	spf=pass (imf25.hostedemail.com: domain of jaharkes@andrew.cmu.edu designates 209.85.160.181 as permitted sender) smtp.mailfrom=jaharkes@andrew.cmu.edu;
	dmarc=pass (policy=none) header.from=cs.cmu.edu
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5366ae57896so86569961cf.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1795828223; x=1796433023; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LCoNBWE3kmGZQJ1kgw8zMrA5EDN0aulmwFxsRmULwsM=;
        b=dxZ4mcO6ztruFboZcW1+Ai1rZnLd8Raa/7wKLl1nrOgxXlSoXQzhkrG8CKVAsybVAl
         AOkKinVCCNpmncvI0oEDgs5dOa8wipXUIXH3BsuWtgH1YaPQ7jjpXXaCUXkT7DYEz0Ve
         +izxCgGjW6MUGnKprXrDxZ9hz9FdKjfxM15Xf1sppL+go1GKj9MpY7rogxjrG9kN+W5D
         S8S0hIPgxxXGdvpu2YW1NFQP8/M0sefxZk4xhi7+QKnFe5Wpfjk9T24o2BWiyyLA6lB1
         eLmtUNybVVNh8XwLUufFa6XY1B6KCb14z+218GgRglEHEXLtJLZ5bhm1PByUKpYpoDSr
         62SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795828223; x=1796433023;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LCoNBWE3kmGZQJ1kgw8zMrA5EDN0aulmwFxsRmULwsM=;
        b=WwZhhRLC5VKlR6LDN/8uxe0NDlkgnnbAcKwCTViRr+jy9aR/m+Zku0zWanzTfzJdiQ
         e3SrXHDAh0vDX7OqCAWWlvo0PMgeyj70ii0jJAQhcypmS4uigleWJvU9Cnrw8h0qKMAj
         HhbIHihGccgpcrqiO7qaQXPPUNHkpkm5nqAl54+SDWDwzbDPIWEgzsONHlvV1in1JBjZ
         9/Kp3zU8ot5JvnZcdQBHQwKBj6j4lfEFDGZi9gwzPlbLBr534UpTTHSvfY0ey5TIQJTH
         JiQE2cS5QnayWRcj3wiNtWRY62ymzINwuPdHSfxlT4f+ffmvTfIjegRG8qsum5ACtTWr
         brnQ==
X-Forwarded-Encrypted: i=1; AL+hErErlXEfaNIyCRn61cfTTyAmBBAlo/m5XnMV1bSpAjxLWakdvELfszyo3lVbWVUjbnQySKhWnfHJ/g==@kvack.org
X-Gm-Message-State: APuU4Z9R1HHvfjzFGog52U7Pp1g3IgCwJ1KoMnu2a6SHeqBaRZC2ArRo
	up5JaFUdpD3j150OSJYUudY9Uud/YBKGv/CIREZqYpuVjT9fYjY1Pi1vL9+NFKCVuA==
X-Gm-Gg: AZFdTZcL9+v+PeyDmgaoaJ7XMVg5v2eVzSmN0iGgA6zsQfKImPoqEt8PAk26t+nG1LD
	vW8BhlCX+46vSwH/2XxtAZEVyhnec2qK+ZnAne2ltqPDb+fU4gk5OjIibuDRAruLqRGtQACud7r
	s6XVm67rTVdenp/Ov/oM+cphMdFjdKpOgldhnGFgrPnqvGvoP9WcMA3Z/8XejgEMSWOh4SfFUvD
	dFqMpS9+ECniIiLa4qcvDoCtwzdjdOiHH0U3Qt9GbamqAPKiGZVQQAr8IzSG2OafQzOvmfuKfVx
	c0KRmsLWnorr9GFs6oFbkt2Ni3+Uj9joZ7RFXAQm4IYse5vaIN33zBlb7Q+Stlf9lV55NOaM9ID
	3WGVIPOF6/W+W0l7uiABLw7P8rq0AHPe7Gorvbol+v7XI57StpfKUEaM0fFUCiDrB5O8Rc6xVu1
	R+7TJw3tyGE0xwwfHNjbL27whHGkr5tyTwqA/NHoBUix8H3rFTJY8g1SQH7/y4n3sDSMC1tw+AT
	qcaQqqu3uNszlDMgGxFYE0dzxbGCep/dWhsqTJcv50O5wR3wJL6IavJkZYs28+m2249+03qMXun
	xxEM62p6Gdw2fd50IiO3GDpJEeO94CCu9AOW1y7kroFBP6Hyug==
X-Received: by 2002:a05:622a:428a:b0:535:f92d:5c00 with SMTP id d75a77b69052e-55d76af8921mr488959251cf.76.1795828223013;
        Fri, 27 Nov 2026 17:10:23 -0800 (PST)
Received: from cs.cmu.edu (tempest.elijah.cs.cmu.edu. [128.2.210.10])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b3a0csm229263356d6.14.2026.11.27.17.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 17:10:22 -0800 (PST)
Date: Fri, 27 Nov 2026 20:10:13 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	David Rheinsberg <david@readahead.eu>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
	Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: never point a file's f_mapping at a
 container's mapping
Message-ID: <20261128010821.irhzl7qcqahz6onx@cs.cmu.edu>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	David Rheinsberg <david@readahead.eu>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
	Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
 <20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC72DA0011
X-Rspam-User:
X-Stat-Signature: o3rurxr7whctzyakdw4ntu9efy64kkuo
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795828223-743086
X-HE-Meta: U2FsdGVkX18aqR7t9U/QztZlhrsGC9Q/E0ofES2LIlO/iaERC8Wh+HH4WYCc6FKo97GUQTn5KCuyALMVp8Sr3nFml/Je1VgfWj3XsEd8sBCxn2Kb/Fq/zFohSy308s1F/0GgYSn/2UyOtrBCHG530xQ+NnvX5RRvi1vr5cSCbNIWa3YVt8tr2Igsg2XiJD21/xopyXJv5DlsiNHfSUZJTjqYd7cdIsJklZbOv7j5hzG7uwnfsYN+h1a/Dya5V1pL3UskhB8PJuQQvSBz6y8DBSQbjH7GPN/On+PJpKehOg89r8qRBY6zUVYYR3/Mc2r8nt1KLrCYnWZvlJsvDrg35dJVHMswUW9HXppBx93sxD14n7xhRSsst+ik9QJHWe9RP39vRLc3/AqutUpPBOOBEIRWgWxJTVfqUTKe+9DlDX87I+DkRiW7RbDD3QK4fIfomIZMPrSkYXHKIxALBGFCHJGXcrV6hlrFJjrjbxIQ/bvlbC2IpSxHWU3Bnn9Y5b+JNqkvmc4jleDyqLY2ISnqe8lHQiK9zvbgzgRHnJgdriAQ5U2W7PIE1HErvDMo/yNbl/dXAhmhpXTejPTia940KU34eb4VW8VtTry02ApLC2SwJeRgumiD2dYIlHrvgFtdR7WE5SJOVwgCBENw18yy5nUt1x4a97P5OZ/z3YLXxVWTi5YmCYJhrXgFpl93ZBdVBxNilJ0D8WgsPg5jGwEtD5fvHwUtIj1wI0BBN4BV128Zgh1aYxcdx99OET7GDl2juEtCnm3lv1r+Kqj/zgtMj+lcX8B5ZtCgM8UhFoRUNvf/FGUevvdYbDDTQFOglab4BwAFBb4ro3vOXzEA8EVhsIg2MAJND/Z+OdTMlDFl2+X2m1mImAzhUXzNM2gPPv8THa9Vkyws3q31CH1bbb5IYutQmqUvuE1DGfODvbK/rO4u7BmsSHQuTnsYh/+M2GxK5//2WmED1C+eChAVqGV
 jjSVZptt
 G5Uf9TUh3tvXrUTtHj+3Dil9I7zrK/a8/FqgjClQw8NOiTXj3YmzOGumf9zj+rDMp4vRuiBjNOjpFqkYOkXktyxzEKGmufr6qU49DFMf1Ni5R9tyFcvS0BHBjw59tFRMeLN5PabZsXc+ZdEr336MURHfTf1aUI1L6ePYOsbxBgQdRw50z3N1rtFJgpz5XBNWftg82LSS2gOIAeQdp6lKFpZNPIE0xykJ1zeO8G1mbUyjY5vZgBtoDc9rGkTSk2qBT2BpH/5cbyLNLAIGPS4HKsptj3mCLVdX8qAijm6EGAREsWjSkwXyH113MaDu2OUsS8XdLeH058uIlgL2nW+B3q1aEn+x464M7jmYwGsR5VtRLI9TWNVwXuP8YRsFZ3pVgPHgeHAYWx34zQuRyIPhS2xtEx+Qy0bmfgyakgcy6L4dGtkak2zb6oDjXsgAPNLMSamU1LsP+rfUQhTHXenij3qWkAJOE6UZHVFnSxobCmRMmsCuqO5byS/tBejvkgSxgP6IbsaFsjm5XHKk++mviSN3k644tmICODYHYfe/EGCDliZtJm1oY8hG5tY30Kd78x8Co6M3qw3EMgVvkeDqLKhzoBL05S0yYKdO4VerNfSd+xUCFvHCwl4s77JqQ0b1PQvMTQsdEQC0mZKNWtHBFc2bWQQAT2KP1bUoqk3w+swnTJTjvp/9vtJCuHHG4s2w9aGYMwVMy0awDUCmmM7GLzRLd3N+6+nHsW8vCOPYx/HnSbXPouBIc3T6eq7dV9duUBx/T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 12:44:28PM -0800, Andrew Morton wrote:
> On Fri, 27 Nov 2026 19:45:40 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
> > Coda file systems stack differently from other stacked file systems.
> > 
> > On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
> > the Coda file's f_mapping for the mapping of the container file. This
> > causes two problems.
> > 
> > Firstly, the container file may not remain pinned, at which point this may
> > result in a dangling reference in coda_file->f_mapping, and so a
> > use-after-free in mmap() or lseek().
> > 
> > This can happen when you open the same inode across two files, mmap()'ing
> > in one, which assigns the i_mapping, and open()'ing another, which assigns
> > that i_mapping to the file's f_mapping, if the cache manager gave the two
> > files different containers. Each file pins only its own container.

Coda uses open-close consistency, so between the first open and the last
close the cache manager does not make any changes to the cached copy, so
every open is guaranteed to get the exact same container file.

Now that happens to be the Coda cache manager, I guess changes that
would enforce this at the kernel module level can be useful, but
dropping f_mapping, I think will break mmap for us.

> Yeah, I hit this while getting
> tools/testing/selftests/mm/memory-failure.c to work on all Linux
> filesystems.

Did you test this without the actual Coda userspace? What was the
cache consistency model your userspace was using?

Jan

