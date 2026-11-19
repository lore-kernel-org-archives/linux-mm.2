Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B087C606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 03:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=BE0J9RGv
Received: by kanga.kvack.org (Postfix)
	id 9372A6B0672; Wed, 18 Nov 2026 22:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9536B0673; Wed, 18 Nov 2026 22:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCA76B0674; Wed, 18 Nov 2026 22:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2546B0672
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:58:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93ADDA8703
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:58:24 +0000 (UTC)
X-FDA: 85450511328.10.5EDF3B5
Received: from out-zbxj-a71.jellyfish.systems (out-zbxj-a71.jellyfish.systems [198.54.127.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73A2740003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:58:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=BE0J9RGv;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf01.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.71 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795060702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3ZgBWWFyiN7Y7ggxmL9phbyLLGbEvqOZM9Wb7bl0Q2Q=;
	b=boEUrNfGENuQYoXfEc2BatjLXzZerWq1x4XfvSL/JqtP7IPkE/yz+07KNbSgKJzeZrVqF/
	H1xVNkgiNGXLbqv7sxCPFZhiKuowTFOs3XUgWDNtUzqrEWOF9A7LgQCdOsmRKVwSx9OV2A
	bzYScmbRvADzIBXJNVGbbx7dYg0aJrk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=BE0J9RGv;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf01.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.71 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795060702;
	b=h0tMCfKyDSZrmYrgpOA3upHllg7zTfIR8KNajYwV2Do01EDzZfqZ8zkJe8iBfzn45M+wJ3
	3iMOY1aiXbWBlvw+v6i8dcjIiJSiD/WprBHtWM0sCyi0ZcnwprTqBoH2lzFOYDO1dB4Iw+
	pOyEsrcTzZJgRfrS/eGxcPBJdgD5dKs=
Received: from fedora (ec2-52-197-241-54.ap-northeast-1.compute.amazonaws.com [52.197.241.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jVPnz3HtXz6tkK;
	Thu, 19 Nov 2026 03:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795060697;
	bh=3ZgBWWFyiN7Y7ggxmL9phbyLLGbEvqOZM9Wb7bl0Q2Q=;
	h=From:To:Cc:Subject:Date:From;
	b=BE0J9RGvC7X0KzuOzUjkcXuSN9kIukq2QpfEtdjBfS0+XzjFGa3r23AGKuJFzDss9
	 inlPVDaPfxPXDb+hBPQkwMGyEcme0lUSq1/5yTGV/NegE0RM8l0CPUHv/IDLX/mh+f
	 Fpy7l7Lgx3GWiI5Z3CuP/yIBXfZWyizr84Hy8e0TSa0aaC9fbswFsQ8fu3ipAv2U47
	 i1N35DQjg9FjCHaQgP0G0dJtAvYpIia340wrdo6zi/McFheZOagkj46mKuRV2Zkk6q
	 KjErmKQPiisfEuNlCjIFJtyZ6N5JZ3Gu+2eI+tj2LvCs2GHxQedtPh94LhFTqrdeYp
	 NswBz/z+e2s4w==
From: Tianyi Chen <hi@tychen.cc>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	hi@tychen.cc
Subject: mm/filemap: plain buffered read evicts a folio left by RWF_DONTCACHE
Date: Thu, 19 Nov 2026 12:58:08 +0900
Message-ID: <20261119035808.431204-1-hi@tychen.cc>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: zwbxm8yfmjbn9j8cc9qyw4jpbuge97ym
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73A2740003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795060701-433225
X-HE-Meta: U2FsdGVkX1+y0z2ICZIdCUUiZ7DqZUOsMQB55368VGfYZEaBazHMEx0zpr/f0B0YjQglywdmPpHDYmhNNLfVyu2U2mZ1M18QOfsMXxL1NqKA/YBpNoG0UAhYMYjV9qnqBNtKkhUafU4CBXVRqkzC0j/1ErUVhXqM7hktNDXCyB5zLASpN8fer4lkBNsRx+vvvLASJcxOiuY1cT/xbI9xVNSuD3ozd3YsCGW3Cpc8EUKk07LFcwOQ/L0ZOPUupzc/+Iec2ivdEZ61fXMBB8Za3ZUDLC67jIIHD/lg939angI5rAZEOAsJOJ5Zzk4fyrqdKMCmZ9lJ2Mdoer4sXjb/SMcRdOH0pxuxU6irUEV9BwBnaziQXNo94isXSXcyCc4/tsJtiiLo3OL75H8zcS9NGImZgQbaMDnXlh5UGE4zYyEAx0ncOZveDaJhIPFPR0aoi31ePt8is6uRbc/Q7obOHfa1jsMl04/BWtLe8+ZR0VVOGyl/7xfp8r+28XGVnkrsniQGzZaDL1uFE6bqL9ml8z+ABLwHN6zutW52APwfDqhajKE/s9wyKTbRJ78imV+gKVNBGDbkkFsxxa7D8IycSbWGF+0J9/WM6Lllal+5M49lDOwlO/vWpX/my0CsW816SiXX6NxczNmIpbIdYDGjkbyWrpFITZe81ktY9VFjY72Kp/Vl6I46XGEv+TblRTaFf7qsJG9qUG6Qzm2JQuyeYblk1QHj8367zA9h64dK/YA4jHt6pu2pCrguXcA6655Lx7Kvk8VgUmFs+95FODGkMYIWUEkCIw53Fx71t23V0wAEk3CdUxjattsldBaY7EaX2jZEwoMC1z6hjUZM8PaaaefEaw5im8gAYzzpAdQ5xa6P/gj9VUlFds/LwHpFBGf17JUKsYClnkIAJ7XQbKWNL6p/JMNNhgODsgcreU65/JVMtJc8vqhqdKFLxJdcRA3CtgbfE1ApmJFT+d+Rm4J
 Uy0ct1z+
 om8uUjXswYBW8yDMEGKkWRh6MTAtKjeGMRj3xslZcBvmQzO4F+9jkEsxQeOZX5EsFAJZ2JAqxOEGu8pqfMYE8vSdxtokccBnsn5L4qkndueCEy3LRQb6EL98Sj8qu9kdl3pXdszbs1yk3cREH29rXDC2h1c0niv6SV0uNWnLMg+Adez2rBmkmdUURyDMb/c+QdW5VY8HhwWdpQ52zsvJ+vNWKrTFpsP7AiUrt3FV3CyNKGs7vD1gj5FcWCOjxAKCaYgas2HCzRRxPEueF1T1vFjGAu5nRrZR8kEqJEbjiWAO0XfJ7M+fW0NKzF5CIymkGvrBfRRQzO0oR373UnPkQ2xRzjXFZJhpU18KldeUbgt3aT8l3yWwcg8B6+PVY8sjbRm8U40VN91Xon/57qthKIRSjQjYA9dzoeRuqrKw0F9cC6/94s00OTBgMg2lKbEO2SCLYxXbp6O8UOFV+tuv1mBmb+K60m8QpHprrVABYnrHojv8PTuIA/aVHx/2QcjyGsKF9P00G878rbOE0+mmVJ3I2IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jens,

On current mainline (4405c18c95d2, after v7.4-rc3), a plain pread() can
evict the page it just read if another reader brought that page in with
RWF_DONTCACHE.

On ext4 I opened a cold file twice. A read the first 64 KiB with
RWF_DONTCACHE and closed its fd. B then read the next 4 KiB, which
readahead had brought in for A but A never read. The page was resident
before B's read and gone afterwards, so B's next read of it went to the
device again.

As a control, A did a plain read and then FADV_DONTNEED on the 64 KiB
it had read, so both runs had the same mincore() bitmap before B
started. In that case B's read left the page in the cache.

When B read the 48 prefetched pages sequentially three times, its
second pass over those 192 KiB issued 432 KiB of device reads (5
requests), against none in the control. The third pass did no I/O in
either case. The results were the same in five runs in an x86-64 KVM
guest. Pages that were cached before the uncached reader started were
not affected in my tests: with a warm SQLite query running next to an
RWF_DONTCACHE scan, the query thread did no extra reads.

On a cached lookup, __filemap_get_folio_mpol() clears dropbehind unless
FGP_DONTCACHE is set. filemap_get_read_batch() doesn't, and
filemap_read() still calls filemap_end_dropbehind_read() on the folios
in the batch. In the v8 FGP_DONTCACHE patch you noted that when there
are competing uncached and cached users of a folio, "it should not get
pruned":

  https://lore.kernel.org/all/20241220154831.1086649-13-axboe@kernel.dk/

Should a plain buffered read hit clear dropbehind as well?

A reproducer is below. Run it with python3 in a writable directory on
ext4 with 4 KiB pages. On this tree it prints after=0 for the
RWF_DONTCACHE run and after=1 for the plain run.

Thanks,
Tianyi

Assisted-by: LLM

---8<---
#!/usr/bin/env python3
"""Use an empty temporary file per arm on an RWF_DONTCACHE-capable regular filesystem."""
import ctypes
import mmap
import os
import tempfile
import time

P = os.sysconf('SC_PAGESIZE')
assert P == 4096, 'example uses 4 KiB pages'
count = 1024
libc = ctypes.CDLL(None, use_errno=True)
def resident(m):
    v = (ctypes.c_ubyte * count)()
    addr = ctypes.addressof(ctypes.c_char.from_buffer(m))
    if libc.mincore(ctypes.c_void_p(addr), ctypes.c_size_t(len(m)), v):
        raise OSError(ctypes.get_errno(), 'mincore')
    return bytes(x & 1 for x in v)

def run(flag):
    with tempfile.NamedTemporaryFile(dir='.') as f:
        f.write(b'x' * (P * count)); f.flush(); os.fsync(f.fileno())
        os.posix_fadvise(f.fileno(), 0, 0, os.POSIX_FADV_DONTNEED)
        with open(f.name, 'rb', buffering=0) as b, mmap.mmap(
                b.fileno(), 0, access=mmap.ACCESS_COPY) as m:
            assert not any(resident(m)), 'fixture not cold'
            with open(f.name, 'rb', buffering=0) as a:
                buf = bytearray(16 * P)
                assert os.preadv(a.fileno(), [buf], 0, flag) == len(buf)
                if not flag:   # Match residency, without advising the target.
                    os.posix_fadvise(a.fileno(), 0, len(buf), os.POSIX_FADV_DONTNEED)
            time.sleep(.05)
            before = resident(m)
            target = before.find(b'\1', 16)
            assert target >= 16, 'no prefetched target outside A read'
            assert os.pread(b.fileno(), P, target * P) == b'x' * P
            after = resident(m)
            print(f'A flags={flag:#x} page={target} before=1 after={after[target]}')
            return before, target

dc = run(0x80)  # RWF_DONTCACHE
ordinary = run(0)
assert dc == ordinary, 'initial page-cache residency or target did not match'

