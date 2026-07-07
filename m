Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E308C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280076B009D; Tue,  7 Jul 2026 17:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257D36B009E; Tue,  7 Jul 2026 17:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147FE6B009F; Tue,  7 Jul 2026 17:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE0346B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:47:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 695871A0452
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:47:13 +0000 (UTC)
X-FDA: 84963316746.03.546CF84
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8524BC0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:47:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JxEpJ9yh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783460831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
	b=eBvc8qwff+eEPYq4FwPPiwx82XEWuZWqBuHZDh+sMpttho9ysTPlRGgLUnnxA+17WDg8LN
	/SCyCS1moUYrx+qvkIKu8c6TOL9Um/d7HoEgbK+9MPnq6GmT80PtIKMus8rM6lgTIf8I2E
	+31yuQS8SyrC17t77HdjmRnZXqESDfA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JxEpJ9yh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783460831;
	b=tkZv9GtFPz3LCNnoZLUFDUa0C385PjQ/a/CTQ+bOEmZiN3ebjJHrqpUJXyT+YZ8fl0Lqxh
	x3AnsTxFTJtuquU6tLhVwuQ826elhwsK2gKvVR0k9cZJAzzCnxlH1eR0xExp7QUkakzkIg
	3RfYBlUOHUgX3pVRHBmp0oq5if8dZuo=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b00d1e7082so12155e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783460830; cv=none;
        d=google.com; s=arc-20260327;
        b=UEdUi8TFCapqOxR4JT4Tuw61n69OihGLZi5v8KmUwT9lS1xHrw7+ewfN2WPJ1Y3LMr
         OkuuVpnAbA84o8aATuRCxz5UL88mMCK6Wi6ZoViFts4qZ9pJLE7sNTqmwNIJsDxIQKIu
         pJbJdSBeUa/EuGO936xUFJIEhBSvc7znHYuof53DFMTzhsF0DaMcbhGdq6qEQ9PJgcmD
         lrkFH2T80/eqdymSs3Yapv1f3gZXdzCoBi34YU+evPCSLt19UvAFz6xjQvtFrsvvgEAz
         PKGYt9a7258z8zPUdT+qlv2kp4502nj/eriJjO9HI+R+QVGeeJ3maOqogoJRjqwsUawM
         xVew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        fh=ICGS/kEOyWr4J3OzzcDYIIoLahTphhpBB5RDlSoAeCY=;
        b=DMgi4ryhX5A/zUYxDwbG6S/2LR38KPM2Xj174gXQB4+XmCvLCRagPsc7Aapr9dy7LY
         hCkSKO2Q+4TmynssjFc2bvqGpFOQWH53ZRtbXe3nNikldsarZYc6eqDe3M36nNgRFHm/
         /3PCjzE0stSWIdSVBbzeuBNwjihkuEVKRgygjsV9zCdwzatghu+7UbxwiKyP0TbEGV/1
         yn4XsqHFNV8+BzSWnVd17Fz8YqLdltJblC7ZIAs7dV81ZoT6zHpvfdV1L49GVZ4kHj5i
         em3jH77RSCosZyxyvvu/bZjyd0ut5gXtZgry7h256pqbEM6KwMenrSzyOsyOKJjTH7km
         mKtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783460830; x=1784065630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        b=JxEpJ9yhmtJzd2m8CCAs8arhVp4/RtRJf3ksSUr1ZaWDLdlxEjPe4rvfWm0cV8EW/p
         eRjmPoc8EFhBzD1f0Yaac5E9wMSloLeOqNIa8JNkACyg2zWljqOqcFG9fFN2Zwjp7d0t
         Plb+LRfxx7WL6b+sxzoiD9kW5F0cmSiVj22EaDXv7uaKIzf13I5pzf10QWLFBhLvv0Fz
         PDxs25fTTeVmWeZZZUYWk/msUWCpHouyKNUZSkgYpTfWSIR2bBkblLd2npBJ/YrmNB7z
         YHec4+uebHsbiX4oBeOKcCkO8v/sTyXxTA95/Qpj3nKBjaWkvpsoOo6EL+/aZfeBo0D3
         YN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783460830; x=1784065630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        b=N07gdFkVC7fkf7619uFjh/obuz0AAKg5sGbGCaYlhPocrdguX2QTqkSsC4TjMHkXgq
         cCf90s4fcVleoJoAjs4cOw5PurOjS+VzB3vt8b/GpBdgp77VlNtbjDky2GDXhs0jL0/v
         RJVPx0SA7jKFTJITI4rOoJ0/0rW9S7+/prHRcP4cnbzQlAP1aTGPvFooCg2SMEGwvB7A
         zkdJqk/Ts/qFFJFCIa8FvboViyjd0XuWK6SfEvGDobczS1net3ymua7fZe1Qitvl8zGk
         kVdsCCixn4iMP6QVTbSuAmdpIk+baAKO1c0hIixh0yjKyQxXQ3jT9tcQ5m2P1XabUJX8
         GcTw==
X-Forwarded-Encrypted: i=1; AHgh+RpcG5jVIWxMcfVy8VntumpcCSwAtt36Ek2E2tBQ8TR0GaTNfTs+GlbS13PjSLKNmql2FW0ZmKQ5RQ==@kvack.org
X-Gm-Message-State: AOJu0YxkT05J+GYfQ78iqVYj3InhK5SOpTO7LxxgzRKjwSoRyXvcc6xs
	EVrZLg4mYLsJ4pgCvkY4YJTPcKn39ASLwYUjRRU54JGVHnDxe6GFpQB2f7FzSQxHJ0RyNOqBHgX
	rdkNkGNegHwY8TwgMwtcAtx3KiYU4JxI=
X-Gm-Gg: AfdE7cmA8ZsALdcvVzbFCVXQERH979AKThLytsMLZ6M0kqPF+Gh0uiZvUEOJWbaRgln
	rQQRzFCZ9m3ElXKOZtttKOnwT7V+Kbu7/rGuiSYIg+3Xemj7QEhJQEZ+MuZpyubYEtyvbdP8KnD
	FsrVtUo+rF/21Ae2roV2+FPm9TSEL1UbDrNf37Uq3pV69J12P2gI/Y3VxWhzCH6NijZDrheO7bC
	bFhlonTsMiVx9/SaSLkorjs+2SgoP/mC4/A4JwLar3GWPdBZGgEub6nnJ0///QyMABlOgjAoqgx
	x+nm+iJEkJQ6jF9uwwI0T4UOoJar
X-Received: by 2002:ac2:5082:0:b0:5ae:bf95:38e4 with SMTP id
 2adb3069b0e04-5b007c1f0femr1110065e87.3.1783460829726; Tue, 07 Jul 2026
 14:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com> <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
In-Reply-To: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 14:46:57 -0700
X-Gm-Features: AVVi8CdOrDVPo69QAX-ampUYh37yFtghXiGRhoBaNYNkFWfhQkG5M-LvH_fSXDA
Message-ID: <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Yosry Ahmed <yosry@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8524BC0003
X-Stat-Signature: drq5p4593z8qymuzofiutbm55kfsm9hj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783460831-112366
X-HE-Meta: U2FsdGVkX19du5Db/u2WGmhJXo79jF8qF1NGrTyRpxUBsH7393MpPhOcrcIUYZBSptmHuy6GZC4E1CRpB3O7lmtNfKk/eirEMQN+txnqfMXvZO85MRzSmLglfB+KXwFtqqDJKxX1EY33AAeiHRfbJ/FT0T7eNBLEcWRbMRlS3FPjXPlXyyK3q3Hx4MRaoQAiyxe/Io2O1jdV7waZIFMEY3AcvkILrFmUitHRU/DZRCgpRw1g1L58xyA1tRVz+XUOEpQWZC77lMnX0B05FQe2rL7AFhB9qJBucnIjsE3Sa2b8FaZ7YpoekqkAXCtiTwCbZePzIqACcNf0wz9efpitZkvaQs+8LPWjm4t/0mgQW+EbApYbzGMxublr053hZ19E6uo9FFxe61eHhZgTkciqrpHKwtpSLRnzY8SyLG94sS6OtlnSKcVI1mxoShfeeZGSoawK5yaG/rUmVeu4OkyJxhsgsT5rLGult+l+PvmI2sgAsEu5E+epq2TTi3ABrnS6nHBvtsFjTc1T55hsiyAlYAPQB5toQkNUdlaUDu2JsSjGTl7/ZypZG1R1YlPFUKJLcX6i92xTt+iX2rBF2Yet41cZ7kyn493xzGNtxIgJPV7+TGygtZSnvJUyhE6UQnwoypv485qbGrcrCeveosAh2uCR8O4mBK14IypmAnFdODAm5Wr2qR3t553UXLp+Vckji9qIhhGrt606YlFIuWjfRo6qGvHqqAJ0rFrQAhi9n85EjXSiO8joyw+UYEymnsHPDgPNNRRWO2v3YwQtHIE0ye5K2KUv0abP/OCylVRM8rx0Tmcn/lVRKwM736jky6ODLmK614D5yk2KrBNCiNMseJMbbNOpBGZrKPYz0BtHB9nQz1JdoF9Av6uPjIx5JCh0sTNmH34HNzHH3mCE+2cdM5LXTf9uXI0Avo8d2ooeosj6y6nvsAeu1GFmVGIakMlVMp7Q00a0dh1mSmUi8Ff
 wDBbqMNt
 VGS9IJothgvxgxBzxAFHE/0iSEUPBj3ysWgGS3jZ4QkvzHZXO/yzQ2B4xOqcuZJysWlJ8etT0TWKYbko8rx3EHIhxWGKbT0NMtil6c6GhOLPsQYglSH9ZNTLFt43KGBQSNmJV8+yHtESp1b5VE03skCPLbNRAFQVP7YLFyvnOFom5Nx/o6rBPkmgg3L183n0CS287TzvECmsAkpnHK3LxG/yTz8W3mTXyfcGuLawCoUqPYF7IZBCuUv3ZKOniyKPMQ+Wddv2w0362qo2M1fhuslO+onPSW0OP1OViSauehubrKyVbHG/pCwTi+YAYVO/awYQyqMAV3WliVi/8I6KzU3gO1a2tqatkN7y3O9TL0oRjalT0WDSyFnsc2Kv3KUEIPRnGEqHsgyed1VMZW1/MTAWOrVZNX7/4dw1OcOFthe1wJfLrqR2wdnckv7RjJHol+WaLo17mw+LXrhTPuGTt/pr0Ew6Pe9vmBJRxNw2BVLo18P0s359ViWQQDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 2:36=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.d=
ev> wrote:
> > >
> > > We were discussing a way for userspace to explicitly trigger a flush
> > > before, which would come in handy for testing. However, we decided no=
t
> > > to expose flushing as a concept to userspace.
> > >
> > > Unfortunately I think the only way to "fix" the test is to allocate
> > > more memory, enough to trigger a flush on most interesting setups.
> > > Perhaps we should scale the amount of memory with the number of CPUs
> > > so that we don't have to keep playing whack-a-mole.
> >
> > I don't have a good idea for writeback, but for zswap out, would
> > MADV_PAGEOUT work here?
>
> I don't think the reclaim mechanism is the problem, but the fact that
> we don't have enough pending updates to flush the stats. Am I missing
> something?

Ah yeah, you're right. Hmmm.

Yeah it sucks, but maybe sleeping (more than the flush period) before
read is the only way. Which
is terribly implementation-dependent :(

