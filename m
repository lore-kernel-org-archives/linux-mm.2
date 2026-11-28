Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B671606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ChhNmfMy
Received: by kanga.kvack.org (Postfix)
	id C0FC26B05B0; Sat, 28 Nov 2026 01:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99626B05B1; Sat, 28 Nov 2026 01:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60E46B05B2; Sat, 28 Nov 2026 01:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 798956B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:23:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 354D81605C3
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:23:13 +0000 (UTC)
X-FDA: 85483535466.15.73EEB0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 571731C0005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:23:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ChhNmfMy;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795846991;
	b=lU0hHsZU9UAw2hVUPw91/ujpeTiQkIUzHpllnqJk5tQSNhZrK+b2i73Prs2KT7U07HQzFS
	C5HBj2is9wJiXFF2lQcsYpdrk41bNJT3BanF4PiGxRJMTKsk7ox6meMaWQPYfr8N+XXJeS
	Z/mK/NetZvruIROPmZGf/4yG4jaeGWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795846991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTtuW/eDk2oXdvt9wdrZZaMl79sbzHRyXPa+arkL84k=;
	b=8aKIA2Iys/ULb+YAsU7GVM3hwCkshezlSkPkyrX5ThZ2zxRfzjrakjmeLHBnpPivkmMD9C
	P1ISu8eqMdKFm1vX5vY9tETHhgeR1w/GHxRIMIYDoeDkoOkWCugLzSS8GZ7ELqaS/+DBXS
	QJbBgo9IEWd7dMT6e1CIzu42J3LMhKs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ChhNmfMy;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ABDC412DB;
	Sat, 28 Nov 2026 06:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DBB1F000C1;
	Sat, 28 Nov 2026 06:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795846990;
	bh=lTtuW/eDk2oXdvt9wdrZZaMl79sbzHRyXPa+arkL84k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ChhNmfMyeP4ZlcWr+LP9M1gmjvgctYMPIlzWsY83EhNxPBeq2WWnH9yZPES9pALV+
	 /kazP36zqNtWuSnZcLB9XRQZm3CPs6DVHYgQCoomLstjIjqIiv8UH6fAuaI9yVzWFC
	 grkSzniHmJ707b757jtFD5MgdIFYR/5uq2B8Ta9c=
Date: Fri, 27 Nov 2026 22:23:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, David Rheinsberg
 <david@readahead.eu>, Hugh Dickins <hughd@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, David
 Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, Alex Shi
 <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pedro Falcato
 <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, Rik van Riel
 <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?=
 <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell
 <sfr@canb.auug.org.au>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-mm@kvack.org, Andrei Vagin <avagin@gmail.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: never point a file's f_mapping at a
 container's mapping
Message-Id: <20261127222308.a372076fef9e470ea264cbb5@linux-foundation.org>
In-Reply-To: <20261128010821.irhzl7qcqahz6onx@cs.cmu.edu>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
	<20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
	<20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
	<20261128010821.irhzl7qcqahz6onx@cs.cmu.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j9r5rqe9i9x9189ck4tqg8cuznmczzby
X-Rspamd-Queue-Id: 571731C0005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795846991-822300
X-HE-Meta: U2FsdGVkX188HTa+d0Ek+xmNOlnJHdwzOp8yeH9gYHo79sIpuiCA1jbTiYjgGiVfAPLNsIdPYuWVLo0OaSNjy/AQhJIBPuJuYtwvCEX0Kb0K4DoVmxqBzyaywJHQpRe3PRBFMrUdCMQGi9M9QJhNM8qFy4E2h0xrmJ6U8y/jLCynK17O0cbecnvsy8mmqW0YXwqEklaO8SNuuDJqGzEmWw8JUFPHBOEF4AXdvttwVfgqohRMfrJ2dZMRKTqFrjgAi0w5EIKebVHkIE02zes/8eBK9dmBHoL+dDKtFRysqXBf2ro2f7GoegYnJk7lBMJ1wfPu+mPnBY+bG2JzmpCr+h9wnjT7CI0vEDxO5IncGGbFUQQak5uqHVywM0WQD17VUThG4dJ7e8QIncuaIMEJd1WVWGHS/B+RhCSAAGDpDhLQpalu4pl3tJ79UeOefUd5emNj4CiChQqA0detOF+rWnqfymYUAy8mXpZtATALtlhcuVA+d4rUgiOLcdrLMHYnGkOqh4rRvS1I717LcOgslLK7UdrG/cWNVE+V8LkXgtNlH1fMIzsVtaG5sMLzfIfiVCGB4VVKRh523vzokr/Lrtfi4YuhjMEH69iyfej2aOV7+iqfSilkMYpZADwCsp8TqCtZrJdoYlnGuhPe0LbnLtgooznxXibHj1wvlFtU7l5Vo6VRuLUGxDcKGhNfo7Ovse06rsgtvIJqTQzrW6cuzgQNttKWjqTe+RDONjPOLg/91LuJ1qG/8HmbOTxsZ+CITGYHm76jTHSAxJVXGtoPq+lIKitWkVSFhU0nKj/WnAOzQY/tEgmnrC4/nV1x6gNxdMGmv2Zc0QOJnoX3JI5pe9HQZHh65dcF8kLJy2PkZpTTpcCCK8k96hUKMOxJnO8CePaJZGY/OY2AWPU2h2w+jJ59Cg2SOWdHeCr1bAW6h9Ge9CRf3oa9DWClTJNR3szDd9U3wZ88+SByOBHlW6p
 oK17CJVP
 3zRksESDlrBkO6k+4JBVgu40S5IEFE14kfD25aKnJkbqtYsAOLKkwvP+NBazLjE2GN4MhYxKXs8O3kjAvzAGWaDERuDEnMlOulVJXC+MCVQOmza6xGz7+e8ykBZae2XeHEDxop+0lLyHWL8+I4QNXytIcE5tbxZ/BjvGUSF0KTlfZVPcm0n9r5U48hs//CIRZyGrs3C5dKOFlTGUnFw3CCHkYui2HGEGS70PXUSEHS+plMRpPG0PEV7nJNfEdM+IZ6SuLMUCqntWnzcYIwMyvXc1PFRb8RgeXysJXBBdMNnKq5iDgh+ARvVynMf3NL/StqNhSlPk5ZlevjHJUbPNrH3+M73eAxYHED3fL64/ByJoOxDpk80SQisNcH3j4GRyemHLTccyvYEbyodBIQjvIXL1ehsfCM9X8i0ofqwwiYS22AIHvR5ENQzA1Xs5bJt5HQcDnoNVdYJ7foyJKwdidxSXUkGHn3jNMFokI9g+QNeVdMy2adnMv9gsx1rNuUQk1dSnpcXkTABaeGOm5H6U/pA8LfHftwtLOGGABugZcOoMIVvK4qWL/1plHbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 20:10:13 -0500 Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> On Fri, Nov 27, 2026 at 12:44:28PM -0800, Andrew Morton wrote:
> > On Fri, 27 Nov 2026 19:45:40 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > 
> > > Coda file systems stack differently from other stacked file systems.
> > > 
> > > On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
> > > the Coda file's f_mapping for the mapping of the container file. This
> > > causes two problems.
> > > 
> > > Firstly, the container file may not remain pinned, at which point this may
> > > result in a dangling reference in coda_file->f_mapping, and so a
> > > use-after-free in mmap() or lseek().
> > > 
> > > This can happen when you open the same inode across two files, mmap()'ing
> > > in one, which assigns the i_mapping, and open()'ing another, which assigns
> > > that i_mapping to the file's f_mapping, if the cache manager gave the two
> > > files different containers. Each file pins only its own container.
> 
> Coda uses open-close consistency, so between the first open and the last
> close the cache manager does not make any changes to the cached copy, so
> every open is guaranteed to get the exact same container file.
> 
> Now that happens to be the Coda cache manager, I guess changes that
> would enforce this at the kernel module level can be useful, but
> dropping f_mapping, I think will break mmap for us.
> 
> > Yeah, I hit this while getting
> > tools/testing/selftests/mm/memory-failure.c to work on all Linux
> > filesystems.
> 
> Did you test this without the actual Coda userspace? What was the
> cache consistency model your userspace was using?

Couldn't figure out how to get Venus working (I wouldn't know what a
coda is if it bit me on the foot!) so a mockup thing over tmpfs was
used in place.

<tries harder>

OK, reran with real Venus and a writable file on the server.  The below
repro makes a writable shared mapping, then opens and maps it again
while the first mapping is live.  All 300 first mappings succeeded and
299 of the 300 second mappings failed with EPERM.  This uses one Coda
file and doesn't depend on Venus changing containers between opens.

That one-line-removal fixes this up.

: Coda changes file->f_mapping to the container file's mapping inside
: coda_file_mmap(). mmap_region() takes a temporary writable-mapping count
: before calling ->mmap() and releases it afterward. Coda's assignment
: makes those two operations use different mappings, leaving the
: container's count too low. Subsequent writable MAP_SHARED mappings can
: fail with -EPERM.
: 
: I reproduced this with real Venus and a writable file on a Coda server.
: Without the patch, 299 of 300 second mappings failed with -EPERM when
: another mapping of the same file was live. With the one-line-removal
: all 300 succeeded, and mapped writes passed the readback check.




I also hit a lockdep splat along the way.  That's also appended along
with a slop-coded "fix" which I haven't even looked at, sorry.  But it
did make the splat go away.




// SPDX-License-Identifier: GPL-2.0
/*
 * Reproduce Coda writable MAP_SHARED failures with a real Venus.
 * Usage: ./coda-mmap-repro /coda/REALM/test-directory/file [iterations]
 * The named file is created/truncated. Use a disposable writable test path.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/magic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/statfs.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	long pagesize = sysconf(_SC_PAGESIZE), loops = 300;
	long first_ok = 0, second_ok = 0, first_eperm = 0;
	long second_eperm = 0, other = 0, coherence_ok = 0;
	struct statfs fs;
	char *end;
	int setup;

	if (argc < 2 || argc > 3 || pagesize < 1) {
		fprintf(stderr, "usage: %s CODA-TEST-FILE [iterations]\n", argv[0]);
		return 2;
	}
	if (argc == 3) {
		errno = 0;
		loops = strtol(argv[2], &end, 10);
		if (errno || *end || loops < 1 || loops > 1000000) {
			fprintf(stderr, "invalid iteration count\n");
			return 2;
		}
	}
	if (statfs(argv[1], &fs) < 0) {
		/* The file need not exist yet: check its parent in the runner. */
		if (errno != ENOENT) {
			perror("statfs");
			return 2;
		}
	} else if ((unsigned long)fs.f_type != CODA_SUPER_MAGIC) {
		fprintf(stderr, "%s is not on a Coda filesystem\n", argv[1]);
		return 2;
	}
	setup = open(argv[1], O_CREAT | O_TRUNC | O_RDWR, 0600);
	if (setup < 0 || ftruncate(setup, pagesize) < 0 || close(setup) < 0) {
		perror("create/truncate");
		return 2;
	}
	if (statfs(argv[1], &fs) < 0 ||
	    (unsigned long)fs.f_type != CODA_SUPER_MAGIC) {
		fprintf(stderr, "test file is not on a Coda filesystem\n");
		return 2;
	}
	printf("coda_magic=0x%lx path=%s\n", (unsigned long)fs.f_type, argv[1]);
	for (long i = 0; i < loops; i++) {
		int first = open(argv[1], O_RDWR), second;
		char *a, *b, check;
		if (first < 0) {
			perror("first open");
			return 2;
		}
		a = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
			 MAP_SHARED, first, 0);
		if (a == MAP_FAILED) {
			if (errno == EPERM) first_eperm++;
			else { fprintf(stderr, "first mmap %ld: %s\n", i, strerror(errno)); other++; }
			close(first);
			continue;
		}
		first_ok++;
		a[0] = (char)('A' + i % 26);
		/* Open while the first writable mapping is still live. */
		second = open(argv[1], O_RDWR);
		if (second < 0) {
			perror("second open");
			return 2;
		}
		b = mmap(NULL, pagesize, PROT_READ | PROT_WRITE,
			 MAP_SHARED, second, 0);
		if (b == MAP_FAILED) {
			if (errno == EPERM) second_eperm++;
			else { fprintf(stderr, "second mmap %ld: %s\n", i, strerror(errno)); other++; }
		} else {
			second_ok++;
			if (b[0] != a[0]) {
				fprintf(stderr, "mapping coherence mismatch at %ld\n", i);
				other++;
			} else {
				b[0] = (char)('a' + i % 26);
				if (msync(b, pagesize, MS_SYNC) < 0 ||
				    pread(first, &check, 1, 0) != 1 ||
				    a[0] != b[0] || check != b[0]) {
					fprintf(stderr, "write/msync/read mismatch at %ld: %s\n",
						i, strerror(errno));
					other++;
				} else coherence_ok++;
			}
			if (munmap(b, pagesize) < 0) { perror("munmap second"); return 2; }
		}
		if (close(second) < 0 || munmap(a, pagesize) < 0 ||
		    close(first) < 0) {
			perror("cleanup");
			return 2;
		}
	}
	printf("iterations=%ld first_ok=%ld first_EPERM=%ld second_ok=%ld "
	       "second_EPERM=%ld coherence_ok=%ld other=%ld\n",
	       loops, first_ok, first_eperm, second_ok, second_eperm,
	       coherence_ok, other);
	return first_eperm || second_eperm || other ? 1 : 0;
}



From: Andrew Morton <akpm@linux-foundation.org>
Subject: coda: copy Venus requests to userspace without holding vc_mutex
Date: Mon, 23 Nov 2026 15:07:44 -0800

coda_psdev_read() holds vc_mutex while copying an upcall into the Venus
process, and copy_to_user() may take mmap_lock.  coda_file_mmap() runs
with mmap_lock held and its access-intent upcall takes vc_mutex.  Lockdep
reports the inversion:

  WARNING: possible circular locking dependency detected
  init/1 is trying to acquire lock:
  (&(&coda_comms[i])->vc_mutex){+.+.}-{4:4}, at: coda_upcall+0x2e/0x437

  but task is already holding lock:
  (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x71/0x10c

  which lock already depends on the new lock.

  -> #1 (&mm->mmap_lock){++++}-{4:4}:
         __might_fault+0x4e/0x6a
         _copy_to_user+0x22/0x4d
         coda_psdev_read+0x19a/0x203
         ksys_read+0x72/0xa2

  -> #0 (&(&coda_comms[i])->vc_mutex){+.+.}-{4:4}:
         coda_upcall+0x2e/0x437
         venus_access_intent+0xc6/0xfa
         coda_file_mmap+0xa2/0x1ef
         __mmap_region+0x87d/0xcac
         mmap_region+0xc3/0xe5
         do_mmap+0x5a4/0x5e3
         vm_mmap_pgoff+0xd4/0x10c
         ksys_mmap_pgoff+0x6c/0x95

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&mm->mmap_lock);
                                 lock(&(&coda_comms[i])->vc_mutex);
                                 lock(&mm->mmap_lock);
    lock(&(&coda_comms[i])->vc_mutex);

This is not a deadlock with a normal Venus, because the fault takes
Venus's mmap_lock and the task which calls mmap() holds its own.  The two
are the same lock only when the mmap() caller shares its mm with the task
which reads the Coda device.

Copy the upcall into a private buffer while holding vc_mutex.  Keep the
request pending if the allocation fails.  Once the request has been moved
to the processing list (or freed, for an asynchronous request), drop
vc_mutex before copying the private buffer to Venus.  The copy no longer
depends on the lifetime of the original request, which its sender is free
to remove once vc_mutex has been dropped.

The allocation is GFP_KERNEL, as are the ones which coda_upcall() already
makes under vc_mutex.

Return -EFAULT when the userspace copy fails.  Previously the nonzero
count took precedence over retval, reporting a successful read even though
the copy failed.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/coda/psdev.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/fs/coda/psdev.c~coda-avoid-user-page-faults-under-vc_mutex
+++ a/fs/coda/psdev.c
@@ -207,6 +207,7 @@ static ssize_t coda_psdev_read(struct fi
 	DECLARE_WAITQUEUE(wait, current);
         struct venus_comm *vcp = (struct venus_comm *) file->private_data;
         struct upc_req *req;
+	void *data;
 	ssize_t retval = 0, count = 0;
 
 	if (nbytes == 0)
@@ -238,7 +239,6 @@ static ssize_t coda_psdev_read(struct fi
 		goto out;
 
 	req = list_entry(vcp->vc_pending.next, struct upc_req,uc_chain);
-	list_del(&req->uc_chain);
 
 	/* Move the input args into userspace */
 	count = req->uc_inSize;
@@ -248,21 +248,33 @@ static ssize_t coda_psdev_read(struct fi
 		count = nbytes;
         }
 
-	if (copy_to_user(buf, req->uc_data, count))
-	        retval = -EFAULT;
-        
+	/*
+	 * The request can be freed when its reply arrives.  Keep a copy so
+	 * that the userspace fault below does not run under vc_mutex.
+	 */
+	data = kvmemdup(req->uc_data, count, GFP_KERNEL);
+	if (!data) {
+		retval = -ENOMEM;
+		goto out;
+	}
+	list_del(&req->uc_chain);
+
 	/* If request was not a signal, enqueue and don't free */
 	if (!(req->uc_flags & CODA_REQ_ASYNC)) {
 		req->uc_flags |= CODA_REQ_READ;
 		list_add_tail(&(req->uc_chain), &vcp->vc_processing);
-		goto out;
+	} else {
+		kvfree(req->uc_data);
+		kfree(req);
 	}
 
-	kvfree(req->uc_data);
-	kfree(req);
+	mutex_unlock(&vcp->vc_mutex);
+	retval = copy_to_user(buf, data, count) ? -EFAULT : count;
+	kvfree(data);
+	return retval;
 out:
 	mutex_unlock(&vcp->vc_mutex);
-	return (count ? count : retval);
+	return retval;
 }
 
 static int coda_psdev_open(struct inode * inode, struct file * file)
_


