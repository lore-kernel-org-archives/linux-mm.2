Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAC3CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A95E8E000F; Wed, 17 Sep 2025 04:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759CF8E0001; Wed, 17 Sep 2025 04:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670068E000F; Wed, 17 Sep 2025 04:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 520148E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:59:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFFB01DCA77
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:59:40 +0000 (UTC)
X-FDA: 83898144120.17.29631D6
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0662B40005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:59:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRX+oIuS;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758099579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOKz7P4HEtYH+i5ElgrU7Bp4EAn43MTUmnEdpQptHBs=;
	b=3rqCIS4jZbi7DNKzdIM6es0M/7MCG3IK50rw7ROnJMgXEgwkRhDWR8q2rvcMhwS+OgLdYT
	cNCgOIAOZWw9JI2XE+J003jX4iDUXUmTQp6dJHjB41v1G6JxEdVNKMIMjCxzzRzywKKbbn
	1FHgEvTxJxsnoWOrjIu2P6ByzQNDrtU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRX+oIuS;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758099579; a=rsa-sha256;
	cv=none;
	b=Y5I+O1bosS19kpA/weUdnRcEpqJkcMUozVZl9EeeVfTC+jnCYQWMEJihhIWn7JhbtPyzYz
	MKTluARzY/ZxPZGU2Ef2nGi8kn1hg+MiohtCV0zqa7EhKq+loR3Fuo66gAhZQUE9+7fKz3
	+frgSNJNsNdTEPJVKKe5XwXY9E5C0eE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b046f6fb230so143584466b.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758099577; x=1758704377; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOKz7P4HEtYH+i5ElgrU7Bp4EAn43MTUmnEdpQptHBs=;
        b=hRX+oIuShdX7lZzUMTLGBSZwweB7y5SFT1JrQa5LEJxyKFLBNmOLngx7J29Fp0L2i+
         eG7wtP9yA4PYnNtolfxsJBQ2Pohp3LzHr1FcRB9V5jqDVKaOGU4wIsIcfTgznKz+5+G3
         BNgW3uPkVa6JhhrPHPSRMJVrCobsjyZngfgnwNPI4gJjWWFcdTYjpVlWV+2vR81iA7oq
         koTSkawzdc5ObJLVPn3B/DLDVNy3NNMqiRzDyUuL4OA/FLeBIaRVrd2MhGO8GNra0AJm
         2sPuJh2wC80875vhzjmYLtb5DDSmJKRp2s3aGzxM8c6DHDRskS1cbm/yy5NAJWBWROLY
         rDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758099577; x=1758704377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOKz7P4HEtYH+i5ElgrU7Bp4EAn43MTUmnEdpQptHBs=;
        b=CBGxhUPHo97PAPrccV3mjdMb7AvwzRXnJBWA2dryJkfjBg9g1Enu5HNFPQeNB+AnSO
         +DF/dwIzy3XKfvK7QNoPcmxpxI3Ze1odBuHhuSTT1ecl4rj7gus0PceC5OuuSYJI5TiW
         V14J98+uOzWjhF/ccELc9zLuKLb7bienR2q3HLQylu5UApIY0mTgiH7IDtJLEv5ipnHG
         e3bQJJhCbt6cGjel2anTqqRUxXT+9mM3VdID4GDcAFwMbXcqvb8e6WLnWm4v4nOL+7l9
         2n1OVc+mYkqyp2nwhjZfnT6mq07dWjccDBVkSTGH6lho6SSa13VV68qLW9OBBOBQ0I9X
         K8mg==
X-Forwarded-Encrypted: i=1; AJvYcCXBlRjukt6ZkRTQZmGZEUzTLZe834RFzoMYlLu/UGhsAPhWmMU5Qa03wsmyeTpAtQOky71LZ+IoVQ==@kvack.org
X-Gm-Message-State: AOJu0YzmvlOGs5WVCKto6hbY+v/xL7D7imLKbOqnZ5GnWgAtf3CRNLPP
	fUPp8mDizPHjMUFmtp624UHNdU2JMH45rdSMqdrS6wwNkpXvv3RYa1jCZDWrly/ivNuw7+1MxXi
	Kd/eVv+BIeyYTL82ck9vH0XxGH7nu2wc=
X-Gm-Gg: ASbGncuwnzxCc1wvqWUP7c/0ytYNlLD8evxSOMSPaJ8QhixBciH3Wh2TEPFqsFHbZzM
	nwZEN9KczQV6cuc9pCDLLxIemk8QDuY0vFX91LTrLhdfAmy2tNax4raX17ByqipjmdLtK9z/uGj
	eLIX58J+iiZvfREUpE4fd0q/heMrwBMKAFumqByN4RA2GgNhCU8Rdhcs6lbXVw/IUOohTstjU+k
	Wq60zw+2IK0xTSeTcM86ckdac36LibBfadbdabe5kbz98kq6w==
X-Google-Smtp-Source: AGHT+IF8FMgkRoO/NnsZ7DpY2fIfWx24GDJaOJTYMMvbCsE2nBH2lhvZ+nLWR7ImqMEp0F3hlSbxGlKaMDHdtZweEec=
X-Received: by 2002:a17:907:a08a:b0:b07:e348:8278 with SMTP id
 a640c23a62f3a-b168286b0a3mr607388666b.25.1758099577296; Wed, 17 Sep 2025
 01:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3> <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
In-Reply-To: <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 10:59:23 +0200
X-Gm-Features: AS18NWCmzvVAdt9cnGznBaPer5VswI6NuC9qGL-CKG8mFwH0Gs_2YwiI-pnnOec
Message-ID: <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0662B40005
X-Stat-Signature: 4nhbgq84wg5amd3tg5cb3iq61dnjhdqm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758099578-319724
X-HE-Meta: U2FsdGVkX1+g2JTOHvybcjVwczJYW1uQwIrY44Tv40Zxyi9ekQFdSAoi1sbAawFb/fjrKz+Vo7GH/TVoveK9iXkKg5Drt8j69EMEjT5A3BuBVvAzeTSGhUTWVc4exRn3pH2QOONYZ0Bgg3rXXSjzTxbDrEdmdutbC4gWOVKVSa//yp/ACrzthaBBWSZWrFA/BkFg07AvG7MGEpkgIK+o185XMEQawHHT6qbYKIlAihg3fG/CcP2G+gd4T/2Bn8+FDmnCGdLl8Mqyb+i2jCKtxgHR20KZiw3cGMb2Fq0RuWPtRrUznHxfIdclUo7lG6T0LOo52Xc6SGo5bo8VyIXryCsY4BcCKDfMgjeLeblvvtJ6NkZdGHQU0gizi77cuBlVx45X5Su0isgX2LG7L+pwq5OQEIqdaHmMzWgSYCsykCvNri/sCxNw1NPFbPEUv4tPTgd0vp1A57Nl15jllCRdnGvH9Bl33x/1UzrD4PtDIxCeEGp9ia6hzYwN4hX0alvZD9yyOX90Hs3tQUMEKIhNae8wE/EeVhJMV0sia1Q8tJuUzogM1n5rsYxCY9z5GpDsmzSj138NwZp5w4YAgzMe0U4xFPnpfmuVmPgKvEEipEVr7KGyNBMJbxi7aLobUc1nrNDDi4GlNnjL/fjT71vo0NiCrS3GSZK+jQ2/A3auzA1JQ5nLs5zBGb2mPqDuim8KA7/BLOBebyU1w8AQ56P7xRohJBuSkQHvgqePx1gG0zgDzChXcjK1bceygmyKRZ+u4HhykkG5Q02B+tb68XctoQuu42mowN9AXc2VHUVtAS5j4vejDcQcAdpkN3U5XvUQX6jI14xdqDZ6TDtVmqkZbSkmTWsZWBS1Hxx6mLAEb0CLCUuZ3iEUEbYg411BB0dndOQgPPpj4W1MGbUoCpdVM3t59UU4GVdF88ZUha8YcrjqUdyuQiSk8RAsDDGgKBN5DxbTES2q13wfhOZ0wO0
 B86p9yPC
 dpJT05cQetJ83T6rIyrei8Y44NmbYe3vlwG9tJczxGTsD44o83z2gCjQ0+OIWe1L5/mMfhGg+XH/EWBEIZ8D90x1X9sTlfq70TLOxkNHLo9pQuyb49IyeJlW6TA5SJtlXUOx+k8CupNj64n796JEMfqeQoIRZp38N+F0Z1bx3vd4ef4WFrGq4UvWMP5E6PrhIdtwB1cfnxBSvvvpDesJe6Pbs3rGmjo7fkWnbuUIEamfzCEK+DH15YEqO5cOU5TiH4uW6INyhkQvYEdnn9DhKQ95SwnVboviIeEub0dCIiNhNh0DCxw+tKjucGnSaEp1zJ6JIsSQPVyc2u5uGKnfYgRBFs+C8QFiyH5Fq99T/5Nv48npTmsIoKMI35/DGX9R8byCgSPnoNhLJa8p29dhemHgxR2HQ6nv1Bz8lAG9yZ1/+1kSX/60l9Z9GAidpsuby2cfX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:38=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:23=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com=
> wrote:
> > One of the ways to stall inode teardown is to have writeback running. I=
t
> > does not need a reference because inode_wait_for_writeback() explicitly
> > waits for it like in the very deadlock you encountered.
>
> Ah, right. No UAF. But I wonder if that's the best way to do it - why
> not let writeback hold its own reference, and eliminate
> inode_wait_for_writeback()? (and its latency)
>

There happens to be a temporarily inactive discussion related to it, see:
https://lore.kernel.org/linux-fsdevel/cover.1756222464.git.josef@toxicpanda=
.com/

but also the followup:
https://lore.kernel.org/linux-fsdevel/eeu47pjcaxkfol2o2bltigfjvrz6eecdjwtil=
nmnprqh7dhdn7@rqi35ya5ilmv/

The patchset posted there retains inode_wait_for_writeback().

Suppose you are to get rid of it. In that case you have a corner case
where the writeback thread has to issue ->evict_inode() for arbitrary
filesystems, and that's quite a change and I'm not at all convinced
that's safe.

> > However, assuming that's not avoidable, iput_async() or whatever could
> > be added to sort this out in a similar way fput() is.
> >
> > As a temporary bandaid iput() itself could check if I_SYNC is set and i=
f
> > so roll with the iput_async() option.
> >
> > I can cook something up later.
>
> My idea was something like iput_safe() and that function would defer
> the actual iput() call if the reference counter is 1 (i.e. the caller
> is holding the last reference).
>

That's the same as my proposal.

> Almost all iput() calls are fine because they just do an atomic
> decrement, but all kinds of scary stuff can happen if the last
> reference is released. Callers that are not confident that this is
> safe shall then use my new iput_safe() instead of iput().
>

Note  that vast majority of real-world calls to iput already come with
a count of 1, but it may be this is not true for ceph.

> I can write such a patch, but I wanted you experts to first confirm
> that this is a good idea that would be acceptable for merging (or
> maybe Ceph is just weird and there's a simpler way to avoid this).
>

So the problem here is where to put linkage for the delegated work.

Another issue is that as is nobody knows who set I_SYNC and that
probably should change on kernel with CONFIG_DEBUG_VFS. As luck would
have it I posted a related patchset here:
https://lore.kernel.org/linux-fsdevel/20250916135900.2170346-1-mjguzik@gmai=
l.com/T/#t

with that in place and debug enabled we can panic early on the first
iput so you don't have to wait to trigger the problem

I suspect the best short-term fix is to implement ceph-private async
iput with linkage coming from struct ceph_inode_info or whatever other
struct applicable.

You can use __fput_deferred() as a reference (put intended). Note this
one assumes the obj is already unrefed, but for iput_async it would be
best to also postpone it to that routine.

A sketch, incomplete:
static DECLARE_DELAYED_WORK(delayed_ceph_iput_work, delayed_ceph_iput);

static void __ceph_iput_async(struct callback_head *work)
{
        struct ceph_inode_info *ci =3D container_of(work, struct
ceph_inode_info, async_task_work);
        iput(&ci->netfs.inode);
}

void ceph_iput_async(struct ceph_inode_info *ci)
{
        struct inode *inode =3D &ci->netfs.inode;

        if (atomic_add_unless(&inode->i_count, -1, 1))
                return;

        if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
                init_task_work(&ci->async_task_work, __ceph_iput_async);
                if (!task_work_add(task, &ci->async_task_work, TWA_RESUME))
                        return;
        }

        if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
                schedule_delayed_work(&delayed_ceph_iput_work, 1);
}

