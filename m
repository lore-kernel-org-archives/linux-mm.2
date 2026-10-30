Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324C5606A331
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kzUJv4ff
Received: by kanga.kvack.org (Postfix)
	id E56316B05B6; Thu, 29 Oct 2026 22:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E083F6B05B7; Thu, 29 Oct 2026 22:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF8B6B05B8; Thu, 29 Oct 2026 22:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 953526B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C4364061E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:11:41 +0000 (UTC)
X-FDA: 85377666402.11.A8A5466
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 097FC80003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:11:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=kzUJv4ff;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crA/drrVuPBte8rst5YBRjdG8mKRZAGvubjNLACa7Rk=;
	b=MzwPplvQSdPlkujEo8fXEkMfpqDz/9NyT5sYsPQd7/0OGTBqbFNdJAzX63dBoR0YjvIzS+
	nDKzEaOKLFanmJZQrUG1C+yP1BuvyVqYIkBk9Y626LGzWbdH8S9S3ZxbsEVIlywwAp6Y+a
	p2lQFSpka7zlXxkhAN/mIQ3z+DjQQlY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=kzUJv4ff;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793326299;
	b=5Nibap02rDjAdqPG5oMOPqGRuu/L8qzTglLHD0Q3BMaB1caC3GYo0UQVhdf7PNd73szlq4
	JudXOvNKT8cj0ewtUQPFmqa3UMGJrd1Z77ol2jWgHit2EDHMmP/7TH6Nlsj1j5x5y5mPLu
	H5DZ0xJegCl4ej4IrbcL1D7i9Lh6qgc=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5ba328513b9so270378e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793326297; cv=none;
        d=google.com; s=arc-20260327;
        b=nvZf6pzp4nreCg1+q9cUt/J329gLvLV60fudjub/AhD6ihNsPqiyrJLbplE3ZMT3Z0
         wGWr3eSiNlv7kij8NZ0nrIZdpFelchXjH8l8gSROuj9tgW261rhHA9pal4MToymmsMsP
         55MAcTIKMYdethxqObNPGfZ20Hffv3soMnWxT1q5ZdqOnQSpI/HV+DHCj0Gr5AXRnC7O
         tnsy6w2ZUTManzko15rbzlCUXy1S87Vwov55vZC+mopclX4bqOh0ny+jSdTl0+2VyQnU
         g4RNlxXXVsALe3TkIejU7DjkSkalVP2k9lYT42JCIH1QI384WLijjRxHo1vxPL6Vmqwe
         bCTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=crA/drrVuPBte8rst5YBRjdG8mKRZAGvubjNLACa7Rk=;
        fh=UFwvygy0bYlYj2g7+XqjQV31FzyYxQyRhh5/bJAMRKo=;
        b=EyfxhEvWEen3twPX+ogZ93f6r13/PC5rTSReSzcN/bxXMaQUkkp2S28oJpgRgxTRh8
         d2rDvL/FhuOZqrbuECsP3VwBqEph+RHzhV5PloKXXUeNSEOXbtGDKi8mSYNYJEhAcQaf
         7T4W0XAgvN0pbjnYFZnIEvSL59bHg9B1ues0RAqEMRVvmg0/hKUNeBBMNMzivNqDr0gS
         jc349bIJ1SpT/tQjRvOLFXBKKTfRMS3cbBNWjyhsoPcg0CQ4FEVr7sQCZ+qB+dvAp/Ax
         TZIjhM/zTlTGCDLKgUyR6ppDS+jY2w8jI+nF5BnQmdetCkqaLCMbpuSnoiN+tUeGk444
         P5/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793326297; x=1793931097; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=crA/drrVuPBte8rst5YBRjdG8mKRZAGvubjNLACa7Rk=;
        b=kzUJv4ffXCEEpEUAyxMV1XcbpwWkOZelzhaH/e2oNHwI4ziMewhMnqfODO5jAoSsLU
         osQci39HpkoPsENZetJwBZlKtt2zCum/2S1+zlNtu8F7fl3Yy/+8l5Xveneu6xsKaUxt
         F8ydgsi7bIa5tS7aCRdo8CgFvxAf2rcPuO0g/zAx16mojvWHs0gCgwRfFP6mrtF0UXRK
         37OhO729TfPaqRomWV1/j3dI3gHIIckWv+MNCC5APEOazvqg/9P9jk1TQqjm21cG5cer
         wYIHs1krx2uN463b3ONFRx3//VyXUie7lJYF3NIiyXBL62WR6yt90318ezJwjDMccnvt
         szxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793326297; x=1793931097;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=crA/drrVuPBte8rst5YBRjdG8mKRZAGvubjNLACa7Rk=;
        b=aPeXY2ewYBWXBMmVz7vHbnT0HMpbSLtwc+sbvZYur/Z4cNCZychPZbbSiNVzpEekh2
         eCb6eM9+DMJkwkPL3jk9kgs51M41crUfaWOA6xgr73QMMepGhXPlB7P1Hzk+k0I/tBjI
         PNhHjuXQTRNOC6sb52TzMIqUDscLG+HmwmcqJNILpyW5XfZWSlNREyEm/aUdKe94FeFh
         JdxYH9EbfD+U3+y2SWC12sQ7cYMzbKWfDGHhqo8lw+7c1N5x8EgeLODdv42BwVmtWIz0
         DwHad/uRGc42qppGM66eyOSt8ToL4enjlqM9hxZHWZEDII9jb7h9Zemfp+m6CAAE9/gA
         MvKw==
X-Forwarded-Encrypted: i=1; AKwUvBzi9EJkVLe2LOGAVa2aK+wPyk/vRKGxPRz5YrB8OJoSgGbKp76WYaHnrX806k37YkmUq4n+4N+CqA==@kvack.org
X-Gm-Message-State: AFq9FYJHH90bICfu6E+6TS6RzLljJXUeBlpZPrXxft49ewvB6IG6Ujab
	sR+JonidXzJe9cm2NN03gRjo2PeIlTssvUvNgvWqc7cW7HygluU+3STOioCEBFM08ex0imOil0B
	6qdfn8SPeWkI1l0EGTs2TibK0rW1NjXhOje6qdtd7
X-Gm-Gg: AYBFou3NfxNEVVa1djkk/kkyAQ8LxB+bnMsK3omml7M0uLWm6DPF0N1qyqsN6PCKoO6
	rFGhFZzxPCU+jDZVBzRyOaKLq27r6fPkdLCKywlE11GPigwD/HUCeYHd4JiLRCeQ4IfGgcxVrlY
	MEtyK4uOK5EnIM+XX+tLow9Z5KozjTyz2QlW+ov/6dJ6J58wFtueMCNt1MCqwDz9kS/+ndsFisK
	FPJdjNHmO+DfTR3kfQl9CLd76G26lRPq+TT1XXwcXtoV0uqCHdI7b9XtOEM6er/f7VBkv2v/7u+
	AGWVXBhIsVKQusXmFxfvJqBCMDE/KJgdySm4r4oRYbjYjrJwy7pR/sA2iIOdbkwRIHMD72a5q2U
	nCQ5tcSWMHzMRzY4TTdxh2f7eQLSRRYvPRw==
X-Received: by 2002:a05:6512:15a0:b0:5bf:b93d:a75a with SMTP id
 2adb3069b0e04-5bfd957985dmr184617e87.12.1793326297270; Thu, 29 Oct 2026
 19:11:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com> <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
In-Reply-To: <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 Oct 2026 19:11:25 -0700
X-Gm-Features: AclHuK_Ui4UCRhuJ1nc0jCjt9G3iqxf-Duoq7MdeFTqjramIg9lV-Tjp2uHPr1Y
Message-ID: <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 097FC80003
X-Rspam-User: 
X-Stat-Signature: 6fi7znujdfw5fszcpmbhhui8dhewa6fb
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793326298-31706
X-HE-Meta: U2FsdGVkX1/tHxhTCd+hqHWsD1gv7yfelear4IetCaWMwianhp+H8k8UpKlqqDbVy6TAswUo2cSf5IJYb2vXnoQVUkDp5u5v3ICck9rIUIV+Jbl+bBUCX0K0jQs26jzJVIu2Ve5CusotrBLYJ+GEAnxamVsVPO97FlfbpU+NiTtE9xhcbHVyNZfQkVeceU5B+uzt+i4jloa+ykx9kXGxm1Y3KyCoBOv1iQWb/NpLzAm1+H4WdgCuNBA1k6hMGNTTMS6KQzANMWt43cU2I4hW9QNMgccv5GoPQv1/mEaCFskkXaXKFdXOsUMu0EWgUK1+VjDCT5ftSJAk7qyCg9g5FcL48hkykQzxfMTmdIl8Rad/LqlNJplnoDU/3oqu/ghYw/zG+774AE/JOyWEk0N+QydwvcsThCdrYQ1/dbraCBXykg263nYQcHpKbe0kGFjkEitWA4pHGCkqIxM/9HeoXTUgPDGXcIw89mvAEavHKZJq6VAdoWsFBpQXekTyC4+qaJP2qCPnXDM5Sj8S86kDJSu7iP/15jckghUs1lI3Wm8pdiZUowIqisE3d22rV9jj2uUxkOSO0zDTJX++OwhzfUX+tmX7ADghf/NiY5lnafvV3xj9+sW9FiSlkX8PdR7StC6xcUic07c5wTkc6iw0EbN2+KFsjT73nOvGsyLdf5hUcGQ3BLLXtp3zPzAhaqTmhu/Aa045x2JB//W4i2rOCAXqwSZauIjLm4CbcSKw6xglbryyxk/xguxOXjj8C6Eo0KE2yfGI23ftJMSl78f7NU5ySA3wGSIHdZyntlsfOVHbkiArFBWO2oUnLIYHI4ZNS/IaLy9ZNuRnfLjDRZx02iB4DHLQAxS6cf/n8VBBUwSHRVxXKYil+Q+CujersZBqjsCtJCOrwKUNmmE/QAPcmypMF5BCsdQzMuxU+A1tBK84PI6dPtcQwQ/sy1htQd4jym9ulcwB/oJzHlxxdrS
 KZIj98mw
 TRJs+XLqhi0h5r2e12fb5VLcKpXh0M4VGVovTh/wBuvFmqaZ9RMWZY0lsmrnWn8FWFLqmu0r3tfBm49NXF8E6MtXB7YodTa1a2JZNLhrpOgYtR3Ng0CaPxU2p8MjqoLvK4InowAFvZO+9xbnyw64CJNi3Il1qpQghKRm+EV29vAa32UgM3jwbPrTe01AucwrL1blI8mvEGhvO5tHt2nmJXiv8Lc2b1R2QY9sWTNYMHy7jycONpollDW0WLR1zIdEluxe6ATI6iTktn5nka8nXD2RKB6q8a4mrHDHvt/TljZYIDX6ILFW5RTViPbGRaBDOlOx+yzbY5MExUaUomELrF+ZAD/e6ApndMdPUXM8mlNP/ZoWVTJAdEUZmwtQgxHmfRmeCEnpNHyF0iWs9E05UPCjU9URRtiu78EXrMkau/wYag8wKxsvKNWQFHvSCovFKxBRBxSLFuShMZfRQTDqORtmR3tpTvPFrDF9VWDma4IGxdYYespeB2PDxJp7ND4EiuSvJXbXhJedtT8ldM82bQa18nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 5:26=E2=80=AFPM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
> On Thu, Oct 29, 2026 at 4:16=E2=80=AFPM Samiullah Khawaja <skhawaja@googl=
e.com> wrote:
> >
> > For live update either approach works. If pinned pages cannot be punche=
d
> > or truncated, iommufd can rely on that directly and the seal is not
> > needed. I went with an opt-in seal only to avoid changing existing
> > behaviour. If folks are fine with blocking punch hole and truncate on
> > pinned pages, I can send patches for that instead.
>
> That needs opinions from other people :)
>
> My two cents are that blocking hole punch (or making hole punch fall
> back to writing zeros) seems entirely sensible, but I'm less confident
> I know what to do about truncate.
>

FWIW, I think a demonstration of weird kernel behavior is clearer than
musing based on first principles, so I had a friendly coding agent
write the lovely code at the end of this email. It prints:

Creating and mmapping memfd and registering it
memcpy "Hello, world!" to memfd
MADV_REMOVE the contents
The memfd now contains NULs!
memcpy "memcpy was here" to the memfd
Using io_uring to read the registered buffer
io_uring says: Hello, world!
WRITE_FIXED completed: 15 bytes.

IMO this is utterly disgusting.  It makes logical sense based on how
the kernel works under the hood, but I think it makes no sense at all
as a matter of actual observable behavior.

Unsurprisingly, the behavior is identical if MADV_REMOVE is replaced
with ftruncate(0) + fallocate(size).

I can't shake the feeling that the problem here isn't so much that KHO
+ iommofd doesn't like this but that the behavior in question is
nonsensical.

My system's tmpfs does not appear to support FALLOC_FL_COLLAPSE_RANGE,
which is probably for the best :)

---

#define _GNU_SOURCE 1
#include <linux/io_uring.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <unistd.h>
#include <fcntl.h>
#include <cerrno>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

[[noreturn]] static void Fail(const char* operation) {
    std::perror(operation);
    std::exit(1);
}

static void* Map(int fd, size_t size, off_t offset) {
    void* p =3D mmap(nullptr, size, PROT_READ | PROT_WRITE, MAP_SHARED,
fd, offset);
    if (p =3D=3D MAP_FAILED) Fail("mmap");
    return p;
}

// Single-threaded, one outstanding request, using the raw Linux io_uring A=
BI.
struct Ring {
    int fd;
    io_uring_params p{};
    char* sq;
    char* cq;
    io_uring_sqe* sqes;
    size_t sq_size, cq_size;

    Ring() {
        fd =3D static_cast<int>(syscall(SYS_io_uring_setup, 2, &p));
        if (fd < 0) Fail("io_uring_setup");
        sq_size =3D p.sq_off.array + p.sq_entries * sizeof(unsigned);
        cq_size =3D p.cq_off.cqes + p.cq_entries * sizeof(io_uring_cqe);
        if (p.features & IORING_FEAT_SINGLE_MMAP) {
            if (cq_size > sq_size) sq_size =3D cq_size;
            cq =3D sq =3D static_cast<char*>(Map(fd, sq_size, IORING_OFF_SQ=
_RING));
        } else {
            sq =3D static_cast<char*>(Map(fd, sq_size, IORING_OFF_SQ_RING))=
;
            cq =3D static_cast<char*>(Map(fd, cq_size, IORING_OFF_CQ_RING))=
;
        }
        sqes =3D static_cast<io_uring_sqe*>(Map(fd, p.sq_entries *
sizeof(*sqes), IORING_OFF_SQES));
    }

    ~Ring() {
        munmap(sqes, p.sq_entries * sizeof(*sqes));
        if (cq !=3D sq) munmap(cq, cq_size);
        munmap(sq, sq_size);
        close(fd);
    }

    int WriteFixed(int output, const char* buffer, unsigned length,
uint64_t offset) {
        auto* tail =3D reinterpret_cast<unsigned*>(sq + p.sq_off.tail);
        const unsigned next =3D *tail;
        const unsigned slot =3D next & *reinterpret_cast<unsigned*>(sq +
p.sq_off.ring_mask);
        io_uring_sqe& entry =3D sqes[slot];
        entry =3D {};
        entry.opcode =3D IORING_OP_WRITE_FIXED;
        entry.fd =3D output;
        entry.off =3D offset;
        entry.addr =3D reinterpret_cast<uintptr_t>(buffer);
        entry.len =3D length;
        entry.buf_index =3D 0;
        reinterpret_cast<unsigned*>(sq + p.sq_off.array)[slot] =3D slot;
        __atomic_store_n(tail, next + 1, __ATOMIC_RELEASE);
        long submitted;
        do {
            submitted =3D syscall(SYS_io_uring_enter, fd, 1, 0, 0, nullptr,=
 0);
        } while (submitted < 0 && errno =3D=3D EINTR);
        if (submitted !=3D 1) {
            if (submitted >=3D 0) errno =3D EIO;
            Fail("io_uring_enter submit");
        }
        auto* head =3D reinterpret_cast<unsigned*>(cq + p.cq_off.head);
        auto* cq_tail =3D reinterpret_cast<unsigned*>(cq + p.cq_off.tail);
        const unsigned current =3D *head;
        while (__atomic_load_n(cq_tail, __ATOMIC_ACQUIRE) =3D=3D current) {
            if (syscall(SYS_io_uring_enter, fd, 0, 1,
IORING_ENTER_GETEVENTS, nullptr, 0) < 0
                && errno !=3D EINTR) Fail("io_uring_enter wait");
        }
        auto* completions =3D reinterpret_cast<io_uring_cqe*>(cq + p.cq_off=
.cqes);
        const int result =3D completions[current &
*reinterpret_cast<unsigned*>(cq + p.cq_off.ring_mask)].res;
        __atomic_store_n(head, current + 1, __ATOMIC_RELEASE);
        return result;
    }
};

int main() {
    printf("Creating and mmapping memfd and registering it\n");
    constexpr size_t size =3D 16 * 1024;
    const int fd =3D memfd_create("registered-buffer", MFD_CLOEXEC);
    if (fd < 0) Fail("memfd_create");
    if (fallocate(fd, 0, 0, size) < 0) Fail("fallocate");
    auto* buffer =3D static_cast<char*>(Map(fd, size, 0));
    Ring ring;
    iovec iov{buffer, size};
    if (syscall(SYS_io_uring_register, ring.fd,
IORING_REGISTER_BUFFERS, &iov, 1) < 0)
        Fail("IORING_REGISTER_BUFFERS");

    printf("memcpy \"Hello, world!\" to memfd\n");
    constexpr char hello[] =3D "Hello, world!";
    std::memcpy(buffer, hello, sizeof(hello));

    printf("MADV_REMOVE the contents\n");
    // MADV_REMOVE operates on whole pages. Remove the entire 16 KiB mappin=
g.
    if (madvise(buffer, size, MADV_REMOVE) < 0) Fail("MADV_REMOVE");
    for (size_t i =3D 0; i < size; ++i) {
        if (buffer[i] !=3D '\0') {
            std::fprintf(stderr, "MADV_REMOVE verification failed at
byte %zu\n", i);
            return 1;
        }
    }
    std::fprintf(stderr, "The memfd now contains NULs!\n");

    printf("memcpy \"memcpy was here\" to the memfd\n");
    constexpr char message[] =3D "memcpy was here";
    std::memcpy(buffer, message, sizeof(message));

    printf("Using io_uring to read the registered buffer\nio_uring says: ")=
;
    fflush(stdout);
    const unsigned length =3D static_cast<unsigned>(std::strlen(message));
    int result =3D ring.WriteFixed(STDOUT_FILENO, buffer, length, UINT64_MA=
X);
    if (result < 0) {
        Fail("WRITE_FIXED");
    }
    if (result !=3D static_cast<int>(length)) {
        std::fprintf(stderr, "Short WRITE_FIXED: %d of %u bytes\n",
result, length);
        return 1;
    }
    std::fprintf(stderr, "\nWRITE_FIXED completed: %d bytes.\n", result);
    if (syscall(SYS_io_uring_register, ring.fd,
IORING_UNREGISTER_BUFFERS, nullptr, 0) < 0)
        Fail("IORING_UNREGISTER_BUFFERS");
    munmap(buffer, size);
    close(fd);
}

--=20
Andy Lutomirski
AMA Capital Management, LLC

