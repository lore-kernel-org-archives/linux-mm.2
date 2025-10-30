Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA77CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A88280006; Thu, 30 Oct 2025 11:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B4C280003; Thu, 30 Oct 2025 11:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B410A280006; Thu, 30 Oct 2025 11:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95CDE280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:34:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2759A56EF9
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:34:44 +0000 (UTC)
X-FDA: 84055178088.12.47FDC8C
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BFA1140010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:34:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XbMSIMz9;
	spf=pass (imf23.hostedemail.com: domain of gnoack@google.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=gnoack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761838482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lOQ1a3T7gC/w5kd3v0pW6TZTXp4rOowVPq9YOCsOHpA=;
	b=1ppYkf1HPZmZ9gveoJEjvhYhwykDFWqG/r9hQhzxvuqfBKqkA5OR2o1K6bzcGokxIY76Y8
	uXnyxShNLzIxGqEgtLZrkNYL6AD/776u4keeclMJhYazXnsenrzc8bukX685taRfszwQfI
	NEdi875uMeNPiJWRPnQvt9vAwNCq5hA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XbMSIMz9;
	spf=pass (imf23.hostedemail.com: domain of gnoack@google.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=gnoack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761838482; a=rsa-sha256;
	cv=none;
	b=ZVIZ6TRfhsuLugdW37Qy9TI7Z/1Vs6mJoTQ60TWUMc3XUphxTZf1QvVX67JhsLOGS5DPWn
	fv2aY619uBkaCCQWvLgCG6LpzPBRVu3TTq6sLiu7WwlyzvYjur6BHKx7EGDrO+Qk0fP/7L
	kH8iTRrmUtUXliJ6Pt9X33+47DVfehI=
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-93e2c9821fcso109846039f.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761838481; x=1762443281; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lOQ1a3T7gC/w5kd3v0pW6TZTXp4rOowVPq9YOCsOHpA=;
        b=XbMSIMz9XrrYp1IPR4HGc1K8kEYoV06tmvV5zYUvf2GREbUkISUuigDNK4q1rUolE1
         OnvfI3gp5Ax1xW07NNN4WeuA4vZcFbFv71jFu7N3e/qpTHTpWdPZxy0SI0C4wMBGGkQx
         p0INPHY7pYTM2Tz9Nan6pj9sEDawIqsInXCshU0DKVpnn5r3wUnCK0KIs5VO4UnG4zAE
         BBF4BOmgYuYR0fOpCuJlwl5Ewn0Ke3x8k6rF6e75Y4IwpyRN4Z6hjBZocak7tkkuHh+k
         b3fG6LGrpDFJOXRmzN84TZvRpGYCBidNlumvDEVAKGLAWrR/z4x/264r1E7agbq6M9fJ
         7Z+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838481; x=1762443281;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lOQ1a3T7gC/w5kd3v0pW6TZTXp4rOowVPq9YOCsOHpA=;
        b=XUy6nsGjNkycbAnUw5RlDj7tSnkJaf/ma3+wQzAV/2JOzYcisJiUPSgbWesCt/TNXy
         6xmIbswK6xODbuNNQ91NHHzpkOH8uI1TTo4jK12ZxAJhzyg6AAYpS4TfxDLLoBU0jYjx
         jwKAyVCUrIK+PZBFfpcRkNoA6Xye96kCe6bEgeCMhwJP4YlbdwKP9tvVfTfVZS6UmlLC
         ETfusIBF1AW0apLiky3uRWz2qyNTX8ZbmVJfI1Ex4kN1wG04o/WTr6Wi32L/tzYw/drH
         w8aTtfzP1CFOybu8JCsVSdNaJrnfho66t1ybArP2sC4/6PSS4laY6S5uh5ZdyZ87vuK7
         UN0g==
X-Gm-Message-State: AOJu0Yy6/DERGix8HtiMpz06Zgk9gaXl1KnPIG96jQvI7/yRhhFk0dmC
	IRnfe7Qwn8crh0BQrPhSlEEUReZ4DTYm0ufVOqoVjv6q/KUN+AOG0BW3F84OB+lzDKMaz5CWrjp
	MhAAO7Cjqttu0NEAu6CIZH/MYZLKsq5pqMn62xfEO
X-Gm-Gg: ASbGncubn98Fiao+3xMziL5AgtHQ8QZcfWvm7qgERwDrA+6qSA8R/Sc7zpE5bU0bk2Z
	G4kWHAo0iUTFF0YuCfmzHwo7oGX572NxYq5KLkSuqln9uTfhm2IKw4Czc3Er9scXrJ8nPbebUGv
	dVOAct/7N8HWg4uc9w9W8jeN5ou0qFyc8M1XxYQd3SuCTeUmG0hDxt0mMEutA4Lvt1NbCKPQ/wZ
	jD/UUV4yC0Tvs2JC9kuzbEUMnIsDHeym4Lh+tvvWu+hzalo84JKqXVy95QGA2j7/51nUiUInbLE
	HJlKrYRdQSGbzIzmspbZGSzNfA==
X-Google-Smtp-Source: AGHT+IGFPRlDpealNzZLuy9JmQPH387+1gus/PsWzpptKjSHaGqJdBee+pNUHwsOg0QXZuj4dhYmuxNsskl/crdcTUg=
X-Received: by 2002:a05:6602:3402:b0:945:a9b0:8ea3 with SMTP id
 ca18e2360f4ac-948229aaff9mr35732839f.17.1761838480883; Thu, 30 Oct 2025
 08:34:40 -0700 (PDT)
MIME-Version: 1.0
From: Big Sleep <big-sleep-vuln-reports@google.com>
Date: Thu, 30 Oct 2025 16:34:29 +0100
X-Gm-Features: AWmQ_blYmEEbMahW_s_9GinZYFD6xkjkmJzqf0dqZCN4XhCkUxtDPBt3m7zO2co
Message-ID: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
Subject: Oops in secretmem_fault()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BFA1140010
X-Stat-Signature: czdgbnr56pob73aohjnttb7ynpbht4mb
X-Rspam-User: 
X-HE-Tag: 1761838482-354471
X-HE-Meta: U2FsdGVkX1+/dxKyxmRMJSY+jyA4O8sLo2ngqRuqb2ZeFJBd6UcFMzOjbyT9J9DAvtygaPM7P3gsiaSldX326ev7ERJZFPcz2gMSGacb0nLRiWY/xm/7cYXNweFFRa6mnYr51U9WhriK0pC29br/b41H4c6YOv9H8qNuXq9y7gg7j2TKuc1v2VAw1oP9J76HQxX8ZdRs9KLjZtaJKLqByAhmW7fkyp/0d9qbjE6GJhfI6nRwVMePCpaZK6S+KIIbUXY0A0bshu4sDhl+kqyTk0nMF3eRe7hDjkBfOvkUXJb9R8B37RAJ6CbOKopcvELTQunedxvWtNBj73Y2R8Df19g+inx/EHptstNKBCsPONgQxIIxhTr553XZO2zXTOcSI9fu0FHNbS7DPazR+x3Vab1Umojmy2PFhBMTLAC/TMGxV4ZGHLxKeuPdYMxmGLxJYv1qdAx76jRAxcUBtWXjuJdwjsrWGVMWdOae1uuranJ/mJER/XXz7rOz0kyj6Y3TMs/UR0kG//yr2nqOMQ6uzaDaPtaJg4XXsxJ8GKaPUXw3ywNwZVzcuHdW/Auc1q597mnlfQ4JDNP2dZsnJ8rqb7JDcR6SDjLnj/rIdoc8vnNCHxlSNqEP5F0GOhyECwkpkFe6Vj8UAk6tLWqC/iCxthYpAo92PA4RZs1pqnWbosBQ0mlQ8R9zsX0vPvHVPxadQJgxxarosXSUntROlmXVdNvekE+PcmJzcOmAG2YIV0QN55wTuV2blWL/W1QhNH2yS2xNCzTKcj/NpQc0tJ1laOl/DoUvwMym3wgVWEnTQxqTUsn+oRwofWw7pla6kNTFi/hK8TQtzyLZllQxFzt+SXubplyNAansVpJQHOEnk9+dn0ZIJRYCpGhGyrkl7l2duHuqBuYZHnIGdlPLb02BxCb0j3c+8nQRcIZnTFC2lqGfrKQ+T4L/HNeny4OHNDqlSaNip/QOLIqqd2wBk7j
 l1RpDbRP
 XvtcKwj2X8Ytqvc3lBKEHNy5c43JgvL07Ra5z0r92TO6PChSx8UafzBtoUWTiUYiCa5jMKbTppuL7ewfkjII9fYLZhsd1TMtLwPKVhHJF2WsuVIlTHAWDCdxLDGXbe67ySxeQglClfIRSIA+Z1ulAMArQvww8CBLYrsbUYE9MVm0W+fO8OtF/T/bGZ2lL6TsBtFaztnkfwUzNnQdG4aCx+IxJDPHQZgqS0XoM5Nf514BJg8OZp5ggEYA3ovVY2u++avBP7OyYT+hzld6kHs1wM7Odi6vRi1QuHuLDLAzIbi/VVOjyyNIYEBBS8zF5Rdd9IR8rP50ZaG5o+jlTW/0KjvNjsxWF2lrXpVccSVugl+fbopq/oRMfKmFrekL5DMjolhwSz4uEAHK6xRj5ELXiEJTG9UaD85a03e9SYk56F9/I7QVonKmYfPhKLqK7nk4WrQfeadL9pvxHtkkvnDlSsz490Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike and Andrew,

we found a bug in secretmem_fault() - please see below for details!

--Google Big Sleep

## Bug Details

Unprivileged code can provoke a kernel Oops by exploiting a race
condition in the page fault handler for the `memfd_secret(2)`
feature. Through the race condition, there is a short time window in
which a newly allocated page can be missing from the direct map after
it is acquired, and when the allocating code attempts to access the
page in the direct map, it results in an unhandleable page fault Oops.

**We believe that the bug has no security impact.**

## Analysis

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new folio for it, mark
the underlying page as not-present in the direct map, and add it to
the file mapping.

If two tasks cause a fault in the same page concurrently, both could
end up allocating a folio and removing the page from the direct map,
but only one would succeed in adding the folio to the file
mapping. The task that failed undoes the effects of its attempt by (a)
freeing the folio again and (b) putting the page back into the direct
map. However, by doing these two operations in this order, the page
becomes available to the allocator again before it is placed back in
the direct mapping.

If another task attempts to allocate the page between (a) and (b), and
the kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.

The relevant code is in `secretmem_fault()` in `mm/secretmem.c`:

```
static vm_fault_t secretmem_fault(struct vm_fault *vmf)
{
    struct address_space *mapping = vmf->vma->vm_file->f_mapping;
    struct inode *inode = file_inode(vmf->vma->vm_file);
    pgoff_t offset = vmf->pgoff;
    gfp_t gfp = vmf->gfp_mask;
    unsigned long addr;
    struct folio *folio;
    vm_fault_t ret;
    int err;

    if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
        return vmf_error(-EINVAL);

    filemap_invalidate_lock_shared(mapping);

retry:
    folio = filemap_lock_folio(mapping, offset); // (0)
    if (IS_ERR(folio)) {
        folio = folio_alloc(gfp | __GFP_ZERO, 0);
        if (!folio) {
            ret = VM_FAULT_OOM;
            goto out;
        }

        err = set_direct_map_invalid_noflush(folio_page(folio, 0)); // (1)
        if (err) {
            folio_put(folio);
            ret = vmf_error(err);
            goto out;
        }

        __folio_mark_uptodate(folio);
        err = filemap_add_folio(mapping, folio, offset, gfp); // (2)
        if (unlikely(err)) {
            folio_put(folio); // (3)
            /*
             * If a split of large page was required, it
             * already happened when we marked the page invalid
             * which guarantees that this call won't fail
             */
            set_direct_map_default_noflush(folio_page(folio, 0)); // (4)
            if (err == -EEXIST)
                goto retry;

            ret = vmf_error(err);
            goto out;
        }

        addr = (unsigned long)folio_address(folio);
        flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
    }

    vmf->page = folio_file_page(folio, vmf->pgoff);
    ret = VM_FAULT_LOCKED;

out:
    filemap_invalidate_unlock_shared(mapping);
    return ret;
}
```

When two tasks cause a page fault concurrently in the same page for
the first time, the call to `filemap_lock_folio()` (0) will return an
error, so both tasks will enter the conditional. Both tasks will call
`folio_alloc()` and `set_direct_map_invalid_noflush(folio_page(folio,
0));` to remove the page from the direct map (1).

Only one task will succeed in the call to `filemap_add_folio(mapping,
folio, offset, gfp);` (2), while the other will get `-EEXIST`.

The failing task then calls `folio_put(folio)` to free the folio (3),
making the underlying page available for allocation. Immediately
after, the code calls `set_direct_map_default_noflush()` to mark the
page as present in the direct map (4), but at this point the page
could have been allocated elsewhere. The code should not use the folio
after the call to `folio_put(folio)` in (3).

## Affected Versions

The issue has been successfully reproduced in the following Linux
versions:

* v5.15.195 (longterm)
* v6.17.6 (stable)

When spot-checking the versions in between, we were also able to
reproduce the problem.

## Reproduction

Our reproducer is written for x86_64.

### Reproducer Code

We can reproduce the bug with the following self-contained C++
program:

```
#include <err.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#include <atomic>
#include <barrier>
#include <thread>
#include <vector>

#ifndef SYS_memfd_secret
#define SYS_memfd_secret 447
#endif

static int memfd_secret_syscall(unsigned int flags) {
  return syscall(SYS_memfd_secret, flags);
}

constexpr size_t kPageSz = 4096;
constexpr size_t kMemFdSz = kPageSz * 1;
constexpr size_t kNumIters = 10000000;
constexpr size_t kNumThreads = 2;
constexpr size_t kMmapSz = kPageSz * 512 * 512 * 5;
constexpr size_t kAccessStep = kPageSz * 512;
constexpr size_t kNumMappers = 1;

int main(void) {
  std::atomic<bool> should_stop = false;

  std::vector<std::thread> mappers;
  std::atomic<size_t> bw = kNumThreads;

  for (size_t i = 0; i < kNumMappers; i++) {
    mappers.emplace_back([&should_stop]() {
      while (!should_stop.load()) {
        void* addr = mmap(nullptr, kMmapSz, PROT_READ | PROT_WRITE,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (addr == MAP_FAILED) {
          err(EXIT_FAILURE, "mmap");
        }

        uintptr_t mapping = reinterpret_cast<uintptr_t>(addr);
        for (size_t target = mapping; target < mapping + kMmapSz;
             target += kAccessStep) {
          __asm__ volatile("movl $1, (%0)" ::"r"(target));
        }

        munmap(addr, kMmapSz);
      }
    });
  };

  size_t last = 1;
  for (size_t i = 0; i < kNumIters; ++i) {
    if (i >= last * 2) {
      last = i;
      fprintf(stderr, "Iteration %zu\n", i);
    }

    int fd = memfd_secret_syscall(0);
    if (fd == -1) {
      err(EXIT_FAILURE, "memfd_secret");
    }

    if (ftruncate(fd, kMemFdSz) == -1) {
      err(EXIT_FAILURE, "ftruncate");
    }
    void* addr =
        mmap(nullptr, kMemFdSz, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (addr == MAP_FAILED) {
      err(EXIT_FAILURE, "mmap");
    }

    std::vector<std::thread> threads;
    uintptr_t target = reinterpret_cast<uintptr_t>(addr);

    for (size_t i = 0; i < kNumThreads; i++) {
      threads.emplace_back([&bw, target]() {
        bw--;
        while (bw.load() != 0) {
          __asm__ volatile("nop");
        }
        __asm__ volatile("movl $1, (%0)" ::"r"(target));
      });
    }

    for (auto& thread : threads) {
      thread.join();
    }
    bw = kNumThreads;

    munmap(addr, kMemFdSz);
    close(fd);
  }

  should_stop = true;
  for (auto& mapper : mappers) {
    mapper.join();
  }

  return 0;
}
```

### Build Instructions

#### Reproducer

The reproducer program can be built using C++20:

```
$ CXX=clang++ CXXFLAGS=--std=c++20 make repro
```

#### *Kernel*

To make the race condition easier to reproduce, we add two
`mdelay(100)` calls in `secretmem_fault()`:

* One `mdelay()` before the call to `filemap_add_folio()` to simplify
  the race condition between the two faulting tasks.
* The other `mdelay()` before `set_direct_map_default_noflush()` to
  simplify the race condition between the task in the error case and
  another task that allocates memory.

We build Linux with a default KVM guest configuration, with
`CONFIG_PREEMPT`:

```
make defconfig kvm_guest.config
echo CONFIG_PREEMPT=y >> .config
make olddefconfig
make bzImage
```

### Command

#### Kernel

We ran the test kernels in QEMU with the following invocation:

```
qemu-system-x86_64 -nographic -m 8G -smp 4 -net nic,model=e1000
-enable-kvm -append "root=/dev/sda1 kernel.sysrq=0 console=ttyS0
selinux=0 secretmem.enable=y" -action
"reboot=shutdown,shutdown=poweroff" -kernel "${BZIMAGE}" -snapshot
-hda ${HOME}/rootdisk.qcow2 -net "user,hostfwd=tcp::10022-:22"
```

The root disk is a simple Syzkaller-like image.

#### Userspace

From within the booted kernel, run the reproducer as an unprivileged
user:

```
$ ./repro
```

### Crash Report

Note: The crash happens when another task attempts to allocate and
access the page. It is hard to control which exact task that will be,
so the crashes can look different.

```
[   18.126690] BUG: unable to handle page fault for address: ffff9a3d060de000
[   18.128071] #PF: supervisor write access in kernel mode
[   18.129101] #PF: error_code(0x0002) - not-present page
[   18.130117] PGD 1b7c01067 P4D 1b7c01067 PUD 23ffff067 PMD 1061a8063
PTE 800ffffef9f21020
[   18.131714] Oops: Oops: 0002 [#1] SMP NOPTI
[   18.132550] CPU: 3 UID: 0 PID: 0 Comm: swapper/3 Not tainted
6.17.6-00001-g40e6d463b4d0 #2 PREEMPT(full)
[   18.134417] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   18.136358] RIP: 0010:ioread32_rep+0x44/0x60
[   18.137234] Code: 96 04 8b 10 89 16 48 83 c6 04 48 39 ce 75 f3 c3
cc cc cc cc c3 cc cc cc cc 48 81 ff 00 00 01 00 76 0f 48 89 d1 48 89
f7 89 c2 <f3> 6d c3 cc cc f
[   18.140937] RSP: 0018:ffffa61780140e10 EFLAGS: 00010002
[   18.141965] RAX: 0000000000010170 RBX: 0000000000000008 RCX: 0000000000000002
[   18.143363] RDX: 0000000000010170 RSI: ffff9a3d060de000 RDI: ffff9a3d060de000
[   18.144765] RBP: ffff9a3d060de000 R08: 0000000000000008 R09: ffff9a3d01298130
[   18.146179] R10: ffff9a3d002fbb00 R11: ffffa61780140ff8 R12: 0000000000010170
[   18.147607] R13: 0000000000000000 R14: 0000000000000008 R15: ffff9a3d01298130
[   18.148794] FS:  0000000000000000(0000) GS:ffff9a3e81469000(0000)
knlGS:0000000000000000
[   18.150053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.150957] CR2: ffff9a3d060de000 CR3: 0000000101aa7000 CR4: 00000000000006f0
[   18.152095] Call Trace:
[   18.152515]  <IRQ>
[   18.152842]  ata_sff_data_xfer32+0x88/0x170
[   18.153518]  ata_sff_hsm_move+0x466/0x9b0
[   18.154146]  __ata_sff_port_intr+0x94/0x150
[   18.154817]  ata_bmdma_port_intr+0x33/0x190
[   18.155490]  ata_bmdma_interrupt+0xcc/0x1e0
[   18.156144]  __handle_irq_event_percpu+0x45/0x1a0
[   18.156909]  handle_irq_event+0x33/0x80
[   18.157536]  handle_edge_irq+0xc2/0x1b0
[   18.158139]  __common_interrupt+0x40/0xd0
[   18.158785]  common_interrupt+0x7a/0x90
[   18.159436]  </IRQ>
[   18.159788]  <TASK>
[   18.160140]  asm_common_interrupt+0x26/0x40
[   18.160836] RIP: 0010:pv_native_safe_halt+0xf/0x20
[   18.161612] Code: 11 86 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d e5 62 1e
00 fb f4 <c3> cc cc cc cc 0
[   18.164562] RSP: 0018:ffffa617800b3ee0 EFLAGS: 00000206
[   18.165396] RAX: ffff9a3e81469000 RBX: ffff9a3d002fbb00 RCX: 0000000433dd2480
[   18.166541] RDX: 4000000000000000 RSI: 0000000000000002 RDI: 000000000000a7c4
[   18.167684] RBP: 0000000000000003 R08: 000000000000a7c4 R09: 0000000433dd2480
[   18.168804] R10: 0000000433dd2480 R11: ffff9a3d001f5900 R12: 0000000000000000
[   18.169930] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   18.171051]  default_idle+0x9/0x10
[   18.171617]  default_idle_call+0x2b/0x100
[   18.172268]  do_idle+0x1ca/0x230
[   18.172792]  cpu_startup_entry+0x24/0x30
[   18.173432]  start_secondary+0xf3/0x100
[   18.174049]  common_startup_64+0x13e/0x148
[   18.174717]  </TASK>
[   18.175081] Modules linked in:
[   18.175597] CR2: ffff9a3d060de000
[   18.176132] ---[ end trace 0000000000000000 ]---
[   18.176888] RIP: 0010:ioread32_rep+0x44/0x60
[   18.177589] Code: 96 04 8b 10 89 16 48 83 c6 04 48 39 ce 75 f3 c3
cc cc cc cc c3 cc cc cc cc 48 81 ff 00 00 01 00 76 0f 48 89 d1 48 89
f7 89 c2 <f3> 6d c3 cc cc f
[   18.180884] RSP: 0018:ffffa61780140e10 EFLAGS: 00010002
[   18.181911] RAX: 0000000000010170 RBX: 0000000000000008 RCX: 0000000000000002
[   18.183446] RDX: 0000000000010170 RSI: ffff9a3d060de000 RDI: ffff9a3d060de000
[   18.184862] RBP: ffff9a3d060de000 R08: 0000000000000008 R09: ffff9a3d01298130
[   18.186309] R10: ffff9a3d002fbb00 R11: ffffa61780140ff8 R12: 0000000000010170
[   18.187741] R13: 0000000000000000 R14: 0000000000000008 R15: ffff9a3d01298130
[   18.189172] FS:  0000000000000000(0000) GS:ffff9a3e81469000(0000)
knlGS:0000000000000000
[   18.190804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.191791] CR2: ffff9a3d060de000 CR3: 0000000101aa7000 CR4: 00000000000006f0
[   18.193164] Kernel panic - not syncing: Fatal exception in interrupt
[   18.194272] Kernel Offset: 0x33200000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   18.195998] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---
```

## Reporter Credit

Google Big Sleep

## Disclosure Policy

Our assessment concluded that this finding has NO security
impact. Therefore, we are NOT applying a disclosure deadline to this
report.

For more information, visit
[https://goo.gle/bigsleep](https://goo.gle/bigsleep)

