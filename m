Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB242C982FE
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEBC6B0088; Tue, 22 Sep 2026 20:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61046B008A; Tue, 22 Sep 2026 20:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02456B008C; Tue, 22 Sep 2026 20:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 656F46B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:50:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D11038065A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:50:25 +0000 (UTC)
X-FDA: 85243196010.29.2F339D1
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id BD2E2180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:50:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQ3srWak;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790124623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kp7pGVLDeZIuFw/AAbBDrZSJ/PImU2S3dffhQlahKjQ=;
	b=gsH7sxLQWPe6VlGYO22huycOMW6VWIHzPHRT/djuH50QM/VHE1uBlC6xVq/vuEm6UdVbgm
	RvH3Iuk/XvR0g+yYOb4ImxYqtTh7hlHmu+02vJrOCqdDH0Nq0acaHohN7AJQKba9PyXl1z
	AoScnWX9Q/7O5xbOiKlv8InulQSlLnk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790124623;
	b=kcr2Go2joHnCAhBZp2HZxyPxIFysLhjuscbxEOw5gGXJ2rV3250LwPKTnlaqYIRrIlQFBb
	TISErzuOlkZS8COLDiAPkzwKxEhsvgDoW5W6QjBVVQMMZkI+HiXxYi30VrvtzqdmOHKon2
	8+ssj+6pmW38hi2Xg7QEG1rO1VGXgBo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQ3srWak;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so1745145e9.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:50:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790124622; cv=none;
        d=google.com; s=arc-20260327;
        b=bV18iE7E32KZg2iPEe6XNa6fOKErG/dOe9ChmtDxGxNdgb05tqGdaLz2KchNrTTI7D
         L/6uztmONhNxkI8dhQpVcfPiH/8kas92JKjcJCaueGBbplEaVc+zyKTYYHkNf0i/f2ZM
         ZPrH6wv3cd5Ol0t0ikxXKpb+z+K3VYjMTwZVwURn94aukKGD07pymcKrnFcKS7lfItkG
         yTWIfWVlgaT5MmB58aZu8uWDfN/tkx67kiYN4+2KidICtrqM9hRc5498nqXhLgv+lvlf
         nrkZybfMJwn0hjCxvZ5AeVQa3gDOqtaoTLws/mD6jHEgKISQ34W3LfJJ4Nw/1Swrw0fy
         BZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kp7pGVLDeZIuFw/AAbBDrZSJ/PImU2S3dffhQlahKjQ=;
        fh=SQhVV6lmFm7vshxwLd+4+hovgly0p3IM4CXuv4F42NU=;
        b=cXSm+EojZ3dWwB4KIxjW9SjgX3qie4tmMRqfq9jEFCtEh/hxYjjGjbQcfHs69me0Lv
         VfTZ90NElzDmD11Eoirj/SmMzoTvVZfx3fT0jzBtK90b3pqOpe7LUYPDd6NWQn9t9qKW
         umc8k44kIfBZA5r97nJPuwOyghh5qD0nAle6WA/+Fkd12KBhCUc3x9k5goiJlcFXL5Mv
         S6EC3wkYIv/Kcvj2OBHk2AgYxmfKESHU2/5Z00LccduD6EJGWx6PTkj2xMdSbU7VRmnB
         W4zalMMv8Zcy5jpvSu2rwisuYfMrOgfEd9qLIrLUOUKccxUbzmu7hkJvu8Xndb82hi4D
         SP/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790124622; x=1790729422; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kp7pGVLDeZIuFw/AAbBDrZSJ/PImU2S3dffhQlahKjQ=;
        b=WQ3srWakBoy+pyuEHTYzTVZriu8QFAyfGq+Z7FaL4s6nqFpMHWy+wNDQhAaPjRTW6A
         pFZqnh3Wa053UfDk5JwX5OoNZrKDRQ0cywVoQN/UPv573HBtulDWsQf/SmE9LeLcm5Rm
         QMzgNVmOHbOAbkobOz4t0Z3IhxqtBTzbIOz9tKFNzllvwLPDRiQ2Y9M0eDzGfpsh7F6f
         MnpYds4N+sZPxq4C7ZAjMdd6qSyH6YFs2dwlgiVDsPEU4udeg3252wysTWb+extYCBfz
         7BL4B2fQIzXOet/An/MLtxp1FaqpPxg6MybxsRjyCBpnDRMNC1Qw5XbP9IxWWMNK+SQF
         ZdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790124622; x=1790729422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kp7pGVLDeZIuFw/AAbBDrZSJ/PImU2S3dffhQlahKjQ=;
        b=ZIn8YVWmXpNKMayJoygWzB4cp2KV4E+jsvpD9eaL0WawsiOSlbg0dYKSXM2inNjqFZ
         1IknCjSavCnCH+hfZdiC0XDpfODp5qSHMuLxVmAkO6hJOALJYZ/ZolP9kFu7+pSAkawz
         56RNuLU/YG2KbeGBP7qRNdqT1tc/H1lJ4hcD7ufaHueM5672ETxm5uiJsRvZbZTRaA4r
         0VKVvCvyROqzq8POSz2AtNZKFDVLyG3LEEk2nGWgM8iYhd4aWVfLTFiJc9L378Vgq0Kf
         XQaE9iVyJnP03bO0ol7ZrF4zM5BOl0gOT/GbYNED1inldC/2AjZfXunx8hpMYDJHJBrl
         8Ocw==
X-Forwarded-Encrypted: i=1; AKwUvBzG/pF9kWVJGNxIio/IMQT3U4OMiWh1xqv3CH/Zrbc6FCxWInYrmBqULVZRM0An7UldeE85klI0Sw==@kvack.org
X-Gm-Message-State: AFuF++klUB0i/Ap+pqZeDFbxnDmqzhwnEMVsgLTr34zk/F7AvmrcXFHd
	SKnpdCSu5XkdZlJOUh7D3YlTmjnNxtq0SItwbpvIg6077JNfvWbbJ0CinBH+vIa5f8q8PWX/eZj
	aTjsG9nTHlOgpYNPJLmZgLG/DGK1/TcM=
X-Gm-Gg: AYBFou336NOtS81v1FZ5j1lVsfVrF3O6Sk031KDzJ/G8XDe02a5CWFlMRDeaoIcSouq
	jPR8jMLrUYB4t4Lz4wIIRUQF4t5rw/vtG98iHlQsBUeDosOALGWfLizHwwt7nVEuZX33pIu35Vx
	81mHHTs0owVX0izzPT8HkKXTITe7N3dx1sLGag46eFxvLxvnwODulUmGBn7IXcayDqDiiS7TXFz
	cAW7ukEHTy98ZnRd5G79pIxCBlRBfwcNHp8V9dyP5XBzEWnf2qOCSNAf7p5/sm+KP9bTjTw0QtJ
	fy9Fpeq3UtcGeYhHM7KzYz//OqsAyDD7cSh7ecv9jxOEzb4Hi/R5qisCyfF1qk2hMMIgenaHDhF
	ZNXWP7AM/5bIALG7mK88Ow3MJGjmvSPpgJ9P18A==
X-Received: by 2002:a05:600c:354c:b0:49f:ce78:3572 with SMTP id
 5b1f17b1804b1-49fdf10d3b4mr8823955e9.35.1790124622063; Tue, 22 Sep 2026
 17:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com> <CADrL8HUdzE_ve49msaHksAYGoKmdr+kcTK0otG9wvsFY9WsywQ@mail.gmail.com>
In-Reply-To: <CADrL8HUdzE_ve49msaHksAYGoKmdr+kcTK0otG9wvsFY9WsywQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 22 Sep 2026 17:50:10 -0700
X-Gm-Features: AclHuK_SioGzgIazlChWrBJjaYQJlOBpv4q7fLV4XkRULQ-7R9IOcZhV_dfMBn0
Message-ID: <CAJnrk1ZHVMk4TZCOkk7Bk1EEME6NSdkgJw--yU6b=N=grsosBg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD2E2180002
X-Stat-Signature: x7wxzysb4nxh5otfipd9qaoqf5ofkrpz
X-Rspam-User: 
X-HE-Tag: 1790124623-610336
X-HE-Meta: U2FsdGVkX1+rHdYY/c6iuyPbmlrXFXR+ppxyhnV4m7mXySoBdc0tHX2zRtd/ggISFtLULcQaXV70q8NgpX6y3GXV86dppYEgmoaOhhGxgwEt721vBsczb/6cgJrwbaON6k+x8ECI8vmhhc+mIiAMtnsC7JRs4coJIsbrXqqS+yUIq+pRvtqVFeZt6LpBWTgUSwPfdMDOgwTqZ7olVZArxEEuobFuh7FXVr1eCtTp39wZIyO8od0M5TAYOjcTProXcj3YCGJ6ZEOLxQW+i/JObV8Gy3eibAQ8+9WvzrlKlV6WgbjAUguDtobSjQiIWbKAFhbhpDAsAIT3NjQBVpyuzMmq5fzlt7FIfvQsWCh/afeOrHnDIPi1akJGqXQoyojHyeKXpbCEfPgFLDJz45yHtqIJARr4j9Xzi/OXsz4mmOOi/9aH57Jvfd/72UnYAL6d5pPJ5HMCkZuX2argf2y4O5W80e0BDyq+/8cmrR0r8+G8TtNXeFK0d3N+XE2vql1LBRWJ5IiAzvfcpj3T1snNhbECIS6fhkvNh+IP2d+J2KFpxav+AC0bXqulPdQJZbHW/QwrBkonoK04cLsmuDgv8QGdGDTgRg3GsrxtAqQk1n7zNn1S88+q+47CDkD+5anCdz0cYMRCXW+sqojlsIFVmvk7b614QmCz8Jz/mMb1L5xZVC/VP3s4G5GkoWjvzVeYm1fnMWqsVg77vpFyJYNVbebFU5rShSter4EACPsDleRLxxKwHoReFAsadjbL+xw/MWlxy9h2qzOlqYrWr9lm0C29caaoP27qbmhqwOta1eGArAGEwsHbiSK8eRAzyXLrNNB7joT9iwZXJbnLpzOuviQNUbbQdvALPaY/ffqR98vWL6hmznej0S9HSMRef4oNsX+Mm4aY7IEfJiZaKTlh4GWHr3L50kQ9U+5KJeyR5w13kzkCLBpE13/1r1HmSlmmYHK9aUCUkmlVdS8/o+j
 5e5Hf0tj
 d3QdrCbLhqP02LqtZyJE0C5MIcFvJlwJLIS/ytpoIpll5etZ3Ls+lcKg+qeDlvizOjjI9oGKRBRPmn/KibWfVtNhTe5a8ZTyOvXT+lQUmQvbu3Ual338F4GtyrreYlqzhy5m+/nWw6YkWCSwcxDyhutOnusy0hrwUn646oVdKH9PQXYYB92Tft3NtMN2oVnlq+jfHdYaBeqTV/wHneDj3ZDlFGq7OWHD5M5l5U/Ydrgk6/wgRVnlZrxrlqt1T0/1HQdfQOo1KogEwa9JwSx1ruttqGVHia3bMPwfuykDYq4+osMOCIarCKTM/s5Fcwo5ooygXfQ9KiwT+IYlb9kruHlGdTDuEi+C1xC1LNbvsOPC6GXtcSn/HXm0eQWL8M4oD2ONV9FYTDnAtgQcQOKHmvvR020qE0wfugckVjNPcFYDRGHS90CMn5xHKgdbA658apt45/FNrA5RwGIMKRLhCS0Hv/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:28=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Mon, Sep 14, 2026 at 12:01=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> >
> > On Fri, Aug 21, 2026 at 6:39=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > On Fri, Aug 21, 2026 at 12:41=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@=
gmail.com> wrote:
> > > > > Would you be able to share the test you're using? I've been tryin=
g to
> > > > > repro it locally without much luck.
> > > >
> > > > The exact test uses some internal testing libraries, we're looking
> > > > into whether we can translate it to a standalone C repro.
> > > >
> > > > From a high-level, the test:
> > > > - Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
> > > > cgroup, backed by shmem THPs. The VM is not a fully fledged VM, jus=
t a
> > > > KVM VM running bare metal code (so 4 MB is enough margin).
> > > > - Enables zswap in the cgroup.
> > > > - Tells the VM to write to 256 MB of its memory.
> > > > - Checks the cgroup shmem usage and that no swap occurred (no limit=
).
> > > > - Sets the cgroup limit to half the VM memory.
> > > > - Checks the cgroup shmem usage and swap again, usage should be ~ha=
lf
> > > > and so is swap.
> > > > - Tells the VM to read the 256 MB of memory again. This should caus=
e a
> > > > lot of thrashing and reclaim, but no OOM kills as all guest memory =
is
> > > > reclaimable.
> > > >
> > > > With the ratelimited flushing, the test started flaking 5-10% of th=
e
> > > > time due to OOM kills.
> > >
> > > Hi Joanne, Yosry,
> > >
> > > I've attached a reproducer for you (as a patch that should apply to
> > > Linus's tree).
> > >
> > > In tools/testing/selftests/kvm, `make` should build it. Instructions
> > > for running it (like setting up swap/etc.) are in the comment at the
> > > top of the file.
> > >
> > > As part of the patch, I've also included a sysctl to dynamically tune
> > > whether or not the memcg stats flush is rate-limited. You should find
> > > that when it is rate-limited, OOMs occur, and when it is not, OOMs do
> > > not occur.
> > >
> > > This reproducer behaves slightly differently than our internal
> > > version. This version, when run with `-b 512M` anyway, seems to OOM
> > > simply by setting memory.max, whereas our internal version would OOM
> > > upon re-accessing the memory. Not really a meaningful difference, but
> > > just wanted to point it out.
> >
> > Thanks again for the repro, James.
> >
> > I added some instrumentation to prepare_scan_control() and have been
> > seeing that the OOM gets triggered in this pathway:
> > a) the memcg is created with memory.max set to unlimited. 512 M gets
> > faulted in. The new anon folios get put on the inactive list. Nothing
> > reclaims them yet
> > b) userspace then sets memory.max to half of memory.current (~271M
> > from ~542 M currently used). This causes memory_max_write() to trigger
> > reclaim logic
> > c) the folios have already moved to the active list (my
> > instrumentation shows 122684 active vs. 179 inactive) when reclaim
> > does the scanning, which means the only way for pages to be reclaimed
> > is for pages to get deactivated from the active list back to the
> > inactive list.
> > d) prepare_scan_control() (which decides if the pages get deactivated)
> > reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> > (the 2s flusher hasn't yet triggered since when the memcg was
> > created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> > still zero. The real values are all still sitting in per-cpu buffers
> > that haven't yet been flushed. My instrumentation shows:
> >         inactive_anon       rstat: 0    actual: 179
> >         active_anon          rstat: 0    actual: 122684  (~479 MB)
> > e) the deactivation logic in prepare_scan_control() is:
> >
> >                 refaults =3D lruvec_page_state(target_lruvec,
> >                                 WORKINGSET_ACTIVATE_ANON);
> >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_AN=
ON] ||
> >                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANO=
N))
> >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> >                 else
> >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> >
> > The if check fails:
> >      refaults !=3D prev refaults: 0 !=3D 0      (false)
> >      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> > inactive_ratio < 0     ( false)
> >
> > DEACTIVATE_ANON gets cleared
> >
> > f) pages don't get moved from the active list to the inactive list, so
> > reclaim ends up freeing nothing. memory_max_write() goes through all
> > MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> > (but it's all on the active list).
> >
> > I saw that the skipped_deactivate retry did fire (on 858 of 4264
> > scans), but not enough to get the memory.current back under the halved
> > memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> > and OOMed.
>
> Great! Thanks for figuring that out.
>
> >
> > imo I think the best fix would be
> > a) for non-root memcgs, revert back to the non-ratelimited version
> > (mem_cgroup_flush_stats())
> > b) for root-memcgs (which if flushed will flush every cgroup on the
> > machine), don't use rstat at all and use the existing node counters
> > instead (which is what the non-memcg case already uses).
> > mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> > stat in the same call. For the root lruvec, the node counter reflects
> > the same value and doesn't need any flushing. It has an error bound of
> > 125 pages/cpu at most, but this is tighter than what we currently have
> > with the ratelimited version.
> >
> > commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> > reclaim") was what switched vmscan to using ratelimited flushing. The
> > reason for this was to fix the stalls from concurrent reclaimers
> > contending on the rstat lock. For the Cloudflare case, kswapd threads
> > were contending on the rstat lock on 8 numa-node machines. That's the
> > global path (eg sc->target_mem_cgroup is NULL,
> > mem_cgroup_flush_stats() turns it into root, so this flush essentially
> > ends up flushing every cgroup on the machine), which gets addressed by
> > adding the fix in b), which takes kswapd and global direct reclaim off
> > rstat entirely. For the non-root memcg case, the flushing is bounded
> > by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> > memcg's stats_updates only accumulates its own subtree's updates, so
> > it takes a lot longer for it to be exceeded than the root's does).
> >
> > I ran some benchmarks to get a rough idea of what a) costs. I set up a
> > workload that allocates 512M of anon memory in a memcg with memory.max
> > set to half of that to trigger reclaim continuously. I varied the
> > number of threads touching the memory, so that N of them hit
> > memory.max and enter direct reclaim on the same memcg at once. I used
> > bpftrace to measure the time spent inside css_rstat_flush() and
> > shrink_node() and used those two numbers to get a percentage for how
> > much of reclaim is spent in flushing. These are the numbers I saw:
> >
> > # threads      flush as % of shrink_node()
> > 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> > 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> > 64              ratelimited: 0.16%       non-ratelimited: 2.52%
> >
> > Between the ratelimited and the non-ratelimited runs, walltime and
> > pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> > threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> > pgsteal within 0.2%).
> >
> > I also measured the lock contention. At 16 and 64 threads, 15-20% of
> > __css_rstat_lock() acquisitions hit a contended trylock with the
> > non-ratelimited version. At 16 threads, the mean flush time rises
> > about 8% and at 64 it roughly triples from the single-thread case
> > (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> > effect of this on wall time or pgsteal between the non-ratelimited and
> > the ratelimited version, and the percentage of reclaim time spent
> > flushing stayed at 2-3%. I think that's because css_rstat_flush()
> > takes and drops the lock once per cpu rather than holding it across
> > the walk.
> >
> > I also ran it with 32 actively churning sub-cgroups under the reclaim
> > target, since css_rstat_flush() walks the descendants that have
> > pending updates. I saw that per-flush cost rises slightly (~24 us to
> > 27 us) but the share of reclaim time spent flushing went down rather
> > than up (4.1% to 3.2%), because reclaim gets more expensive faster
> > than flushing does. I don't have a ratelimited baseline at 32 children
> > though, because with the ratelimited version, all the runs I tried
> > OOMed. I think this is an alternative repro to the OOM issue but
> > doesn't need/have KVM dependencies, so if this would be useful to
> > clean up and send as a standalone C repro, please let me know.
>
> It will probably be useful to send with the (a) and (b) patches. If
> it's not very clean, just including it for demonstration is probably
> fine (doesn't have to be merged).

Great! I will clean it up and attach it to the patches.

>
> > (Also btw (this is a bit tangential to this OOM issue, but somewhat
> > semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> > checking really does anything in practice. On my benchmark runs, the
> > "refaults !=3D prev_refaults" check evaluates to false in pretty much
> > every scan. Even with flushing working properly, it didn't trigger on
> > 1673718 of 1674912 samples, even though the cgroup was thrashing the
> > whole time (a separate run of the same workload counted 6371860 anon
> > refaults vs 6523 activations). I think it's because reclaim is
> > scanning faster than the refaults counter advances, so it'll almost
> > always see no change. I'm not sure how much this matters in practice,
> > but I think effectively in that check above in prepare_scan_control(),
> > deactivation relies entirely on the inactive_is_low() check.)
>
> Interesting finding. Maybe Yosry will have something intelligent to
> say about it; I don't. Yosry will be back on Oct 6.
>
> >
> > What do you all think about adding a) and b) as the fix for this issue?
>
> It seems like the right thing to do to me, but I'm not really an
> expert on reclaim. I'm guessing Shakeel is happy with this too? I'll
> remind Yosry about this thread when he gets back on the 6th so he can
> give his opinion.
>

Thanks, James! I will hold tight until the second week of October then
:) Thanks for the update on this - I appreciate it!

> >
> > Thanks,
> > Joanne
>
> Thank you very much Joanne, sorry for the delay getting back to you.

