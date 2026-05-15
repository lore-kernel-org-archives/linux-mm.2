Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1A5CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887756B0005; Fri, 15 May 2026 13:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838346B0088; Fri, 15 May 2026 13:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700796B008C; Fri, 15 May 2026 13:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59DA26B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:07:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8752160396
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:07:07 +0000 (UTC)
X-FDA: 84770284494.11.CCF4930
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FF47160010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:07:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DV7bKO0H;
	spf=pass (imf08.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778864825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQnzcBlc7+y3xboPXu3CAuDhwWayfDkxWRZzNgig+eE=;
	b=vjD1Sw05zXBhVXhXWLbGoWkKYGWCIXMcozLEmBoRIML91DfVQfu3A2I+zaNu3ig8iT/1O5
	st2J9goLIF7Q7NrXeSjE3DnwAnKiHTld1QRfr3+wXQqu7Rw9LVh2v//+8G4kl79IsNL4hx
	iTEUFP90sRvdd/W6jU6zNLGbCS1TSR4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DV7bKO0H;
	spf=pass (imf08.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778864825; a=rsa-sha256;
	cv=pass;
	b=PIL0/nydaps4GC1LGboPKAoaW+P0j2t2XNI/M9SS3HSdBXR3AlIRVbGi5U4Ge6tvxDrFSU
	E2Fn6fpAMuVkERtrNLtxLSCjXWiAzmJ9IMwk+/0uQEtZn7WAkm9uyCgiAtY5PgCfbxCHRd
	U5DFWWAR96Mo5QDVo+utNQTPwG5LgeE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso535e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 10:07:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778864824; cv=none;
        d=google.com; s=arc-20240605;
        b=C1c6lwAeJna3uSVgiD/AXTBEEDhD63KbZJnAwi2lZe39DKLo0fX/jz/Hou9Uzw2VBq
         ZoGRpR3NFXalH0kQYHeMEkYOz9bsYXzoVNKiaPbOWJKiCtyAJk8LboMpIHibKBGTbQuW
         eZsRUC/8QD2X/0JYp/IRVRiJvOhJ1bNOEkSE4sar4L5GrQiZYvbmCLJG8MjADVlLZh/0
         ZqBOQ8Dr3lE2Ae6ed1DUwan7DC32oOL3Acj1SrifClMgge6Qf19LHTuUkt0j6JRDmDRy
         1JOt3Gos019OGD+ceUbA7DyV7hXfkvryUZANwDa+GLyqm3uTViCImwBBHufX2hHfIzAu
         yUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LQnzcBlc7+y3xboPXu3CAuDhwWayfDkxWRZzNgig+eE=;
        fh=T0diVk5pvHx52y0wd26qP/EEe4Ta0qRw98JczbXmPDU=;
        b=RGKX7POVcaDshMyJrSU9fKVpeSnMF79gs8kWKTVCe6LTX+lZol18LGP72YOVpTkxOs
         nkuQBFmQcZ0zXGAaTXqpQTjmjNlPd/SAVq7fNCLYMHmIgWIyE9RWn1RzZ+gNakXew7NZ
         Ra7U3t32un2G7Oyju1zsdEsQJAOgEPrqyrLPovn+CESH1EL9XAV4WgD2NoE5wrTdue0j
         OmLc2eWhj0Jb3APWEnIgrCEYe5jeknSncRMvflcPcg4czTvjlP6Ts161iCWeOo4E0crU
         SEupjTNCLTaXWPMXagXg8jzyca422+PZC6dwS9AYP6ariT4rxu34KCvuzw274ZY9vstI
         q9cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778864824; x=1779469624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQnzcBlc7+y3xboPXu3CAuDhwWayfDkxWRZzNgig+eE=;
        b=DV7bKO0HrPoWZAcJunE0I1ayvEyqRu/RuOjVwbIrW3ve1agdUuJiiueixmdqb8Yct+
         XSAgd1ewyYXwVS3Jp1pPazpKEU7xyMbs/jzEuRZDC9zZpQILWEtlB9Zs3m9VoULA5JAl
         OL1ZvoBOtEn5FhMrks3c97DvTPxeBJ/SBkqKDJ0QpXehSTSzZZfESD7cLtsD2xof5RDp
         RQFkYmREL0GPQeimfWzZD+ywSCfzviWgTgI44VH1SBK/zqvcVH8zMLAQsdMMst5dga2z
         UXlp/ORUnwvX+uwbCS6lAp9bN8LWOSZUyjzHNxxubm7MgGH6cjt6CdgsGbhiZKH8VLSG
         3rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778864824; x=1779469624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LQnzcBlc7+y3xboPXu3CAuDhwWayfDkxWRZzNgig+eE=;
        b=Mv/NxQkmMF7YT1booynlAiK3d4ELTdSHwrYS/8LUeCulo3h9GyRpyp6qvfiQnqm3hL
         9DeoiSqtnbuEHyDjEeFzF7OSzpiONRv+wahB9q7RwSQywFbVauLwUXzwQy+QGW7ODjID
         bpJvPzn0wgrPREjpjsLLNXbYrz8rozU0xACCuvSPflOitwH7ShhMSH1sfYYhRX8YyzQ6
         G7qmeS0qo7xO65814c93o0T753qrM5dR+iC7gPDy9RKbhUPbIkKQou/o5hixvz3j5Nii
         ZqXRKgIXpdoz1vAhHGNC9Sh6+32uR7pkebtBsLbg78u//fbgFaoJ+XB37jTn1k4djsWv
         IHzw==
X-Forwarded-Encrypted: i=1; AFNElJ/pfU4hdJvqJHeIpNblw4D/L7XjcJDyKr/iaGqA70P425MHPLw0UIDar3T3UaNOZY/JRkDWS5d9iQ==@kvack.org
X-Gm-Message-State: AOJu0YxQ3OUpmZ/EiijWSBZ47iPDdtQtQvAmBVlIRtwZfaerkLZWCIlZ
	QuYV/70hSLhRl9T+DvGyMCjBiPM9s0S8zAbrpqJIFmSPe2qUabDAfUZAMF0BS4B71sADurAbzQ1
	b4f9z6Z+b4kHS8u93/eSrbZ615fA61c4zKfl1wNT1
X-Gm-Gg: Acq92OFJ24XeCcAibiP7p+aglubNIObnB6b5Af2dH9uG4SaSdgO2xZmSWkMbNM4IGy7
	hlEkTA3xzzflc7OeCcr/X4WBZhx/RRT/aL9kKXpS9ph7QTL54ms06iJ9DkWchbRV7csaJZ65Tao
	sWhY0wP96kysyzoygGczRjNMHCQgy2q+e13FNhr4SKzrf1zJ7aK0TzPEWPjKhdIkYuY9ZsVXqdq
	aepmWMEvNdCPjvOmiISrUZMYHIgyBpPB15v1gTou/NeH9Z9O7cGI6CAUDTCVLCCvjWZt4Z0g/Bl
	wuPMH6Iphn0VV2RZuheg/4/d1iBOg+dBdojbHiZiOb1Fkej/
X-Received: by 2002:a05:600c:4999:b0:489:1adc:f017 with SMTP id
 5b1f17b1804b1-48fe881e582mr645715e9.5.1778864823481; Fri, 15 May 2026
 10:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com> <20260515-hinschauen-effizient-9e3a05a94f2e@brauner>
In-Reply-To: <20260515-hinschauen-effizient-9e3a05a94f2e@brauner>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 15 May 2026 10:06:50 -0700
X-Gm-Features: AVHnY4LllvNrEvKpMMJyjJvPlkuCoR7DSmB99jM3FHC68bpYwfg1MyASdUtT0JM
Message-ID: <CABdmKX0d6Zsg+_TxXjB80UZR23ZvXzxYoWzORgwmx=ZiuE+Nzw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Christian Brauner <brauner@kernel.org>
Cc: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FF47160010
X-Stat-Signature: hmo87uszt9i716cywig1mbx1jp5j8ipg
X-HE-Tag: 1778864825-604300
X-HE-Meta: U2FsdGVkX18CtVkC3tXfowQsO4VOyNtD98sfzYbX0MPCj7k2vyaEbXFOETXqjHJTLKcldWOhH44pH8W2/UTl6CMyaxmqFrR5yKevoG8h59DhPdIZErC/CijleMvXeHN5zCQQ355+6P6p2sn7162UzErfp2jiqGLp1q6eWkPY6XUuiBcZqtITpaQWF70gfbmYOSQIfq3B/MM87ezuE3X3HCBD4BJsccQZbE3G5G1OQNxWaaZdGgwFlpLu91MS2j4Ncd5aiBQ8X8PxZp2R4QTlhF43O6/w42+hANN87VNWxb87GV14doQOMCucBxoiFaNPfP0YOVcmKMR2p2Txki3Goml8t3ofNYjX10qHJ1Yasz3LOo5LpvFGyxRb7vyLTKdg/tSN8PbvI6vDWDtZi46EcIy1FCpybdgH40qyotNOpd0Dg7zIa7bDtghXprdnGMviSi91xu4ItyCK2ODs8gwHOWV3Xn7gGmpURBtbOkCA77+mbB2IGatq83mmWrpITmpcb4+xqPlhS98jLug+3OLugjWZEBuRi7BdVf2xpdXJlvP717AjcMGmvMV/r2w9RASaHvhcXr7uXlj9AmwALJslS4jw9Qz4JhZc5CTxe7lW1miDZwlwDFucG+gYVaOvSwXfEpsDep6URniPrZ0pgKaehN7RaIe9NMDm3p8Qz+dXjemUtcnlVMhOEPj091UxwdDfjlzPnGHog0dRjJY3odrL8DGJiZzY949nsA2Ac9FeADRdhjiyDS3lMls315DcOIcquH3Kz+7hbdnVXNfl4yYO6Re7JW1X76ppD/zOg/vcZh2SkYKF+0pbl56wGwVbrUrUGpvFFc5u+XSI11lvJRT7aoBPe9tVddOJccLl7XiKUhDNnrjmE+7a/Pvb3eMEqMoYUGLmB+B2hr0Lr4Bta8C8/iowWvKu6IW2e/bEp9w42oMhzzjsvEKPtwUr1//UlCv7d21JXd0w/mrJEvHFyGK
 AcE87Q9L
 CY7hgT+V+V0y9S9yI8zD1Mv6w+b7rOTSAShrpaTrhqqZdkqwZf9Wo+whIOkatUDkaLCHwbM57nRBcC9LJypbaG0xKkM49YuxSYwMK+W2AnZZuH/2d7ZkXJ9kFN/PFeVufL1e6jQDe8KMkuTjL1nGyKjT/H+anMMTXMcxvcj2A5obhS1mGq80iZicGMv17tb23Q/nF5FLXMlH6GaVXRCq8w4hHmJH71H3AA5GkyvCr8I+BRcBQ/i4XYdkcwcoG7KBedHvZKLlITgnfG5jpswHMB9Vi9fyDjQYV37ldJJ7B0B9xUSSvZsL1IpCG6aLZtGRnqDoGck8tnietIugVGM+V7T0KurwwST9wUhKa1SJxDEYJhSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 6:53=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
> > On embedded platforms a central process often allocates dma-buf
> > memory on behalf of client applications. Without a way to
> > attribute the charge to the requesting client's cgroup, the
> > cost lands on the allocator, making per-cgroup memory limits
> > ineffective for the actual consumers.
> >
> > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
>
> Please be aware that pidfds come in two flavors:
>
> thread-group pidfds and thread-specific pidfds. Make sure that your API
> doesn't implicitly depend on this distinction not existing.

Hi Christian,

Memcg is not a controller that supports "thread mode" so all threads
in a group should belong to the same memcg.

Checking the flags from pidfd_get_pid would be the best way for an
explicit check of the pidfd type?

> > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > the mem_accounting module parameter enabled, the buffer is charged
> > to the allocator's own cgroup.
> >
> > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account for
> > system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> > page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and route
> > all accounting through a single MEMCG_DMABUF path.
> >
> > Usage examples:
> >
> >   1. Central allocator charging to a client at allocation time.
> >      The allocator knows the client's PID (e.g., from binder's
> >      sender_pid) and uses pidfd to attribute the charge:
> >
> >        pid_t client_pid =3D txn->sender_pid;
> >        int pidfd =3D pidfd_open(client_pid, 0);
> >
> >        struct dma_heap_allocation_data alloc =3D {
> >            .len             =3D buffer_size,
> >            .fd_flags        =3D O_RDWR | O_CLOEXEC,
> >            .charge_pid_fd   =3D pidfd,
> >        };
> >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> >        close(pidfd);
> >        /* alloc.fd is now charged to client's cgroup */
> >
> >   2. Default allocation (no pidfd, mem_accounting=3D1).
> >      When charge_pid_fd is not set and the mem_accounting module
> >      parameter is enabled, the buffer is charged to the allocator's
> >      own cgroup:
> >
> >        struct dma_heap_allocation_data alloc =3D {
> >            .len      =3D buffer_size,
> >            .fd_flags =3D O_RDWR | O_CLOEXEC,
> >        };
> >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> >        /* charged to current process's cgroup */
> >
> > Current limitations:
> >
> >  - Single-owner model: a dma-buf carries one memcg charge regardless of
> >    how many processes share it. Means only the first owner (and exporte=
r)
> >    of the shared buffer bears the charge.
> >  - Only memcg accounting supported. While this makes sense for system
> >    heap buffers, other heaps (e.g., CMA heaps) will require selectively
> >    charging also for the dmem controller.
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> >  drivers/dma-buf/dma-buf.c               | 16 ++++---------
> >  drivers/dma-buf/dma-heap.c              | 42 +++++++++++++++++++++++++=
+++++---
> >  drivers/dma-buf/heaps/system_heap.c     |  2 --
> >  include/uapi/linux/dma-heap.h           |  6 +++++
> >  5 files changed, 53 insertions(+), 18 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 8bdbc2e866430..824d269531eb1 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1636,8 +1636,9 @@ The following nested keys are defined.
> >               structures.
> >
> >         dmabuf (npn)
> > -             Amount of memory used for exported DMA buffers allocated =
by the cgroup.
> > -             Stays with the allocating cgroup regardless of how the bu=
ffer is shared.
> > +             Amount of memory used for exported DMA buffers allocated =
by or on
> > +             behalf of the cgroup. Stays with the allocating cgroup re=
gardless
> > +             of how the buffer is shared.
> >
> >         workingset_refault_anon
> >               Number of refaults of previously evicted anonymous pages.
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index ce02377f48908..23fb758b78297 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -181,8 +181,11 @@ static void dma_buf_release(struct dentry *dentry)
> >        */
> >       BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
> >
> > -     mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size=
) / PAGE_SIZE);
> > -     mem_cgroup_put(dmabuf->memcg);
> > +     if (dmabuf->memcg) {
> > +             mem_cgroup_uncharge_dmabuf(dmabuf->memcg,
> > +                                       PAGE_ALIGN(dmabuf->size) / PAGE=
_SIZE);
> > +             mem_cgroup_put(dmabuf->memcg);
> > +     }
> >
> >       dmabuf->ops->release(dmabuf);
> >
> > @@ -764,13 +767,6 @@ struct dma_buf *dma_buf_export(const struct dma_bu=
f_export_info *exp_info)
> >               dmabuf->resv =3D resv;
> >       }
> >
> > -     dmabuf->memcg =3D get_mem_cgroup_from_mm(current->mm);
> > -     if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->s=
ize) / PAGE_SIZE,
> > -                                   GFP_KERNEL)) {
> > -             ret =3D -ENOMEM;
> > -             goto err_memcg;
> > -     }
> > -
> >       file->private_data =3D dmabuf;
> >       file->f_path.dentry->d_fsdata =3D dmabuf;
> >       dmabuf->file =3D file;
> > @@ -781,8 +777,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf=
_export_info *exp_info)
> >
> >       return dmabuf;
> >
> > -err_memcg:
> > -     mem_cgroup_put(dmabuf->memcg);
> >  err_file:
> >       fput(file);
> >  err_module:
> > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> > index ac5f8685a6494..ff6e259afcdc0 100644
> > --- a/drivers/dma-buf/dma-heap.c
> > +++ b/drivers/dma-buf/dma-heap.c
> > @@ -7,13 +7,17 @@
> >   */
> >
> >  #include <linux/cdev.h>
> > +#include <linux/cgroup.h>
> >  #include <linux/device.h>
> >  #include <linux/dma-buf.h>
> >  #include <linux/dma-heap.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/err.h>
> >  #include <linux/export.h>
> >  #include <linux/list.h>
> >  #include <linux/nospec.h>
> > +#include <linux/pidfd.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/xarray.h>
> > @@ -55,10 +59,12 @@ MODULE_PARM_DESC(mem_accounting,
> >                "Enable cgroup-based memory accounting for dma-buf heap =
allocations (default=3Dfalse).");
> >
> >  static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
> > -                              u32 fd_flags,
> > -                              u64 heap_flags)
> > +                              u32 fd_flags, u64 heap_flags,
> > +                              struct mem_cgroup *charge_to)
> >  {
> >       struct dma_buf *dmabuf;
> > +     unsigned int nr_pages;
> > +     struct mem_cgroup *memcg =3D charge_to;
> >       int fd;
> >
> >       /*
> > @@ -73,6 +79,22 @@ static int dma_heap_buffer_alloc(struct dma_heap *he=
ap, size_t len,
> >       if (IS_ERR(dmabuf))
> >               return PTR_ERR(dmabuf);
> >
> > +     nr_pages =3D len / PAGE_SIZE;
> > +
> > +     if (memcg)
> > +             css_get(&memcg->css);
> > +     else if (mem_accounting)
> > +             memcg =3D get_mem_cgroup_from_mm(current->mm);
> > +
> > +     if (memcg) {
> > +             if (!mem_cgroup_charge_dmabuf(memcg, nr_pages, GFP_KERNEL=
)) {
> > +                     mem_cgroup_put(memcg);
> > +                     dma_buf_put(dmabuf);
> > +                     return -ENOMEM;
> > +             }
> > +             dmabuf->memcg =3D memcg;
> > +     }
> > +
> >       fd =3D dma_buf_fd(dmabuf, fd_flags);
> >       if (fd < 0) {
> >               dma_buf_put(dmabuf);
> > @@ -102,6 +124,9 @@ static long dma_heap_ioctl_allocate(struct file *fi=
le, void *data)
> >  {
> >       struct dma_heap_allocation_data *heap_allocation =3D data;
> >       struct dma_heap *heap =3D file->private_data;
> > +     struct mem_cgroup *memcg =3D NULL;
> > +     struct task_struct *task;
> > +     unsigned int pidfd_flags;
> >       int fd;
> >
> >       if (heap_allocation->fd)
> > @@ -113,9 +138,20 @@ static long dma_heap_ioctl_allocate(struct file *f=
ile, void *data)
> >       if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
> >               return -EINVAL;
> >
> > +     if (heap_allocation->charge_pid_fd) {
> > +             task =3D pidfd_get_task(heap_allocation->charge_pid_fd, &=
pidfd_flags);
>
> Will always get a thread-group leader pidfd and will fail if this is a
> thread-specific pidfd. pidfd_open(1234, PIDFD_THREAD) can be used to
> open a thread-specific pidfd.
>
> > +             if (IS_ERR(task))
> > +                     return PTR_ERR(task);
> > +
> > +             memcg =3D get_mem_cgroup_from_mm(task->mm);
> > +             put_task_struct(task);
> > +     }
> > +
> >       fd =3D dma_heap_buffer_alloc(heap, heap_allocation->len,
> >                                  heap_allocation->fd_flags,
> > -                                heap_allocation->heap_flags);
> > +                                heap_allocation->heap_flags,
> > +                                memcg);
> > +     mem_cgroup_put(memcg);
> >       if (fd < 0)
> >               return fd;
> >
> > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heap=
s/system_heap.c
> > index 03c2b87cb1112..95d7688167b93 100644
> > --- a/drivers/dma-buf/heaps/system_heap.c
> > +++ b/drivers/dma-buf/heaps/system_heap.c
> > @@ -385,8 +385,6 @@ static struct page *alloc_largest_available(unsigne=
d long size,
> >               if (max_order < orders[i])
> >                       continue;
> >               flags =3D order_flags[i];
> > -             if (mem_accounting)
> > -                     flags |=3D __GFP_ACCOUNT;
> >               page =3D alloc_pages(flags, orders[i]);
> >               if (!page)
> >                       continue;
> > diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-hea=
p.h
> > index a4cf716a49fa6..e02b0f8cbc6a1 100644
> > --- a/include/uapi/linux/dma-heap.h
> > +++ b/include/uapi/linux/dma-heap.h
> > @@ -29,6 +29,10 @@
> >   *                   handle to the allocated dma-buf
> >   * @fd_flags:                file descriptor flags used when allocatin=
g
> >   * @heap_flags:              flags passed to heap
> > + * @charge_pid_fd:   optional pidfd of the process whose cgroup should=
 be
> > + *                   charged for this allocation; 0 means charge the c=
alling
> > + *                   process's cgroup
> > + * @__padding:               reserved, must be zero
> >   *
> >   * Provided by userspace as an argument to the ioctl
> >   */
> > @@ -37,6 +41,8 @@ struct dma_heap_allocation_data {
> >       __u32 fd;
> >       __u32 fd_flags;
> >       __u64 heap_flags;
> > +     __u32 charge_pid_fd;
> > +     __u32 __padding;
> >  };
> >
> >  #define DMA_HEAP_IOC_MAGIC           'H'
> >
> > --
> > 2.53.0
> >

