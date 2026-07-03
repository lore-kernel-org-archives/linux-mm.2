Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38D00C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5026B00B4; Fri,  3 Jul 2026 07:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166E26B00B5; Fri,  3 Jul 2026 07:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CF86B00B6; Fri,  3 Jul 2026 07:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB8096B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:24:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DF141A0505
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:24:30 +0000 (UTC)
X-FDA: 84947232300.21.5444991
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5C0CA0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:24:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=btkxHrkz;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783077868;
	b=oISIPI//AtxTwsRqY1RZouEcZLwqul5aX6rXwVT6nhVoGfiYcIMhgPdH4t5EFgTeKyxgx4
	ucxb09W0lbvMVjE7xlv3tNeEE7gu0HaxasMsoExmFVfarNqbg4tmi2ILsphPAj+arTxFMS
	Ft1kmBJfyhsGk80LzyUlwdGC1DtbbqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783077868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n17w8bkbdYcKF+4kwASzBBp0Rz/4YcqSgLJnMesWzKg=;
	b=Bge1liR1znFMExz+J6ZS5nM54mm7wq13YFYFEkrMhZiUoLWzGyNst1d2bXgYRIIA63vgci
	f7ODbsgtDJH9d1jJd6uNPMY6Vu7qHRsgEw4hSjt88lqgml0O3COp4UNFRTB0HutvziQWvV
	JsUCsYGE3ORXsqq2Iup1DMF73KH2i5k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=btkxHrkz;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n17w8bkbdYcKF+4kwASzBBp0Rz/4YcqSgLJnMesWzKg=; b=btkxHrkzCM4wV6isED0eBgRsyL
	wwGgzJ6GKqoqppe6E8Q4D9rTHXf2Hph6UVag5NZvod4BsLIxt3cg3PcoclVxTWVafHPVaQahr89Np
	4lMCW/r/KGYOGO+vU8LA2jtXK9HkXrztzoQv9OquY52DCx98NFS43gnp0W1hO7tNzJyJnP3lf/LE7
	baPDHMoSz46F6TsffR+YQt4pcHYPhQbIE/xcM682GDzhTomftlk8Y/eN8LGeRxI8RX3MN303TPN/Y
	SFcPFDDAoGL0OPlmfg+Bk9jYQ3qg1MfzozX157BNyy/8pe9f0ab7AvXojHCXCDbBe/y7w70KGCn2j
	DWQoluyA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfc0F-009Miy-36;
	Fri, 03 Jul 2026 11:24:16 +0000
Date: Fri, 3 Jul 2026 04:24:09 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <akeX8mFiizd65pDw@gmail.com>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
 <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
 <akYkKgWOsYnw6ETE@arm.com>
 <akZ4tzQw70x3RR2D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZ4tzQw70x3RR2D@gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: k4qsqnt9tj4zgy5isfmh4m5k7axetgkm
X-Rspamd-Queue-Id: A5C0CA0003
X-HE-Tag: 1783077868-784518
X-HE-Meta: U2FsdGVkX18TfmNAj/20oym7ou5qLF5hnzUDP+kicEGJGLrHDHxqz/zOpFIkv/eymeD5Tr5EzwkJU9vTPtIIHRPdDlxR3n1qB9U5zDMolHcd4QvjUJ+UPRHRtslUzfjVrWGEnDVizW56pgcsupFFAkSBnpWi9RF2iotUMn+k9gXhODSnsWW30RgVVenERk6q1Q8lLOrykTC7lm6YWG/0BrgLnJQY3Nxz13R+QZxTpKMp3l2xlau6EbQZ5yDQpqcMGZ8NcrnGpKCdSq3mw3Sl4SoiA6EMljO5NjxcRqo/cZZyFakK1Ba9w1mZxcJqf99D9BPChp0cUarTwiYvsc9+AcTGd7ILVd7IU/Y979P6zWMvt5vrvz/VFFk+QtnV4CjzFHaR3lGGou5A4bhdRaZ+pvEQyc/3xjSfiuPhkf/v9idrSxZnc8ueydevliQF6MAKrxviW72+EwDgQIEK/rheKolKKw+q5t6ucar0GChBeDbNasIDHNO7/zRvLjv7qhzUA1XXYTgcs0cWm88nQKMZlKsrGNMhFZBMPgDk9zoi3SYUKbNo3u4SBoT6+4dn0YRzJ8h1ylRzg3J2dFwnGyAFK5SJGwFDKYQsuYlFCMGgi0Z4GAPja46wiA+QAgsvYtV07CAHnfNQ+hxph3DaUxFFFP3XVq3VvGu+3o+3e1cttCL32ABJooY9fD1YlCNsK4JM6NfLShTRzoAHqO2YHZiOGUR2RrYm0dTVilTb2nnZY033u5q24tjwjdmqkg4B/NT3pUXBUwQcUztkCk4mpiF3IeBURHsS8EKxfuaSA55dmGvRIiphBHEMNE6S0QoIIeD8H11DLnwKZa8P59H0cDHuoJHOiH/22UcgzGnpsTgdzSkzS4FQSKhJd9m49R6xQBGNOxG1Mvp8e8gpgWtNms7OLqBiRcRgkCMmLyWy+qjSrUds9ZoGJzTgeLVi7qqnEmrW7EbkMNrV0eH8aKV7WV0
 QSoigHu5
 eftcY1AcvgKD/tfHcScgKvqJLUP2ruMKcGHNBSimIa2KSxT3lplteV/QeqPg/P26sz0T0oUuxnxUx4PuEa2t6g8mcIX1cjvn8NtgdtrTlJmNg8Z131qiddDxmT0IzIgYhIi0pgCMVzRFMkk4a5iuWAfjW0xrZspgrkjp+4YoCTg+4SuVEbugvC3ELTMVIdwul9cBNpU1TpuBxswpF0rgbNtNSIuiCVLWXxA1Ye20heZPBJBTqP7cwLL3FNPrgvdR36zCi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 07:55:42AM -0700, Breno Leitao wrote:
> On Thu, Jul 02, 2026 at 09:41:14AM +0100, Catalin Marinas wrote:
> > On Fri, Jun 26, 2026 at 08:52:03AM -0700, Breno Leitao wrote:
> > > +pass "min_unref_scans=1 immediate; =2 gated to 2nd scan (counts $first/$s1/$s2); param read-back ok"
> > 
> > Are these off by one?
> 
> They seem to be OK, and I've tested it multiple times.
> 
> > Kmemleak has a mechanism to detect live objects
> > via the checksum. A side effect is that on allocation, the checksum is 0
> > and only after the first scan the checksum is changed.
> 
> I got the impression that checksum continues to be zero for these
> objects during the whole life time? (weird). 

I've investigated this a bit more and I found something interesting, in
our per_pcu checksum. The code in update_checksum() is:

	for_each_possible_cpu(cpu) {
		void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);

		object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
	}

From my naive view, this has two concerns:

1) In the kernel, crc32(0, <64 zero bytes>, 64) is zero, and the samples' test
I am using (kmemleak-test.c) has:

	pr_info("__alloc_percpu(64, 4) = 0x%px\n", __alloc_percpu(64, 4)); 

alloc_percpu returns ZEROed memory, so, we are checkingsuming zero content.
Because we are using 0 as seed, that is returning zero.

object->checksum is a bunch of 0 XOR 0 XOR 0 and so forth.

2) that XOR above seems very weird. Basically we want to detect if some of
those per-cpu areas changed, here, but, if checksum goes to zero if two object content is similar.

Let me give you a simple example. We have SMP=2, and both objects have crc32 =
0x42. At the end of that function, object->checksum will be zero, given 0x42
XOR 0x42 is zero.

If both object changes their content at the same time, object->checksum will
continue to be zero (although the content (and checksum) HAS changed).

I understand we want to detect any change in any of these per cpu field and
catch it independent of the CPU. I am inclined toward that.

	--- a/mm/kmemleak.c
	+++ b/mm/kmemleak.c
	@@ -1409,8 +1409,9 @@ static bool update_checksum(struct kmemleak_object *object)
			object->checksum = 0;
			for_each_possible_cpu(cpu) {
				void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
	+                       u32 seed = object->checksum + cpu;

	-                       object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
	+                       object->checksum ^= crc32(seed, kasan_reset_tag((void *)ptr), object->size);
			}
		} else {
			object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);



Once this is fixed, then I priming would make sense.

Please let me know if my flaky logic is worse than usual this Friday.
 --breno

