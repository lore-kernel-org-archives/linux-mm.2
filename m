Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A86A606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=obH7tJHE
Received: by kanga.kvack.org (Postfix)
	id BDE1C6B05B4; Fri,  6 Nov 2026 12:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F016B05B5; Fri,  6 Nov 2026 12:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E266B05B6; Fri,  6 Nov 2026 12:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E91A6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:25:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16616C010A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:25:32 +0000 (UTC)
X-FDA: 85405370904.18.7D4FB2B
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 19AB780005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:25:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=obH7tJHE;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793985930;
	b=AWbkoAedNlEDM6D2DFavLrBs/7LYWowzMZKP4l+IO83KPQcWMEHNOU80smhUhVj7E+axOS
	QFPmL5+aJPqqfXZF0MO8+3J9sk12HLDzqPmJvJ6xyc1dWcgF0eLR8W2hvSeo+/+0QE/kLw
	6/xX5zG7RWkR6hGAgujo+EzeLpkdNkQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=obH7tJHE;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793985930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
	b=N43Q0IuakoMvfrXPYzV4cJxmuK6kAmlkKgDBOXApnuj39IbIu5/yH1LhsxtgbVmgZxrCpE
	0kqeGewqOZ0YE9oikXaPreSMlZP2jyT+POGC0DGVWAIRZAb9q1eaptFpMnlsLJM6SP29zT
	5HCw9aD+hFlBtwJwpD1whdCBelZC6ik=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so1425e9.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:25:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793985929; cv=none;
        d=google.com; s=arc-20260327;
        b=b1MMffXmf+LD66sYq1ucIZWQIZCUAYCMdy4wWvc2Js+aHqS7HKLwi8Ipp7FbWJ4IKN
         9Ke1dxJEaVekz2GH1NP6LSErieygz+Aqzt4tZKaYRJNBqDy9QcvJgHDkpugaytyff2NP
         rYzp0rX0MVHXpl3KGLNZ4EGlMKOyea6KBIeXNuqSRN1jQEngO+/+8FV9weR3OShZnuiU
         kHBl0xko4kGao31Nyayp6C7HtrM5OsH0oqLdVBX2W9+tY4rmuGzA5Dmbd2B5wOUJBHJA
         VlJtbmFprgA9vFScnn7gZZyfIvg6OeASrdKg/BBLxIyH20DxeWVZ6ggY29tVJFS2Af4v
         v2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        fh=8z9IHfdRBhmVb2lU4u0+9bRhe14gx2HIjBMrntX+Ens=;
        b=hzGw7wP4NHPPMrrJHXd2D71i5CddKjU8cclk5Y80yM4qu4EqSsvhfz9SSi1yAmYeMP
         V5+ScpiV6p26fblOCnLmUHfIDa+8IlQXBqkmYzR/LltjTtJWBgJ7xpGJRRTmo6URT28a
         ePTChk9dPx/4/Bb6ntJp1J/zxLNIjBjzhNDXP35h0ej8WP8+AO0igZkv6vE2Iw0pIWZU
         RgYPlZnbVZmPAAMDtVXNiI25Osp/YMwas3dwHnq9j0RTaTzWWnk2ziFNPhXoyyioak5K
         qatRiq3mwId0G+vSXYQryIn4HW1bk+omeGZuqM6sBJ0iCySgpfWKZgpTdX6TbvVs533v
         BRdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793985929; x=1794590729; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        b=obH7tJHExZkRbcPQ3md7DIkpPjoMKPS3I9sRwOfYSR9ZYMn5qYZu3LMzVvfVIEOF6G
         fp6GzVE3EsIo3AtPwK0+wt8lNWGnx6/lVjLHdQGb+tkC4subNZomRkPyRVwgFB60xNyX
         8806wxGIa+XixiaUfwWL0y8SO7qrGEqYhHMx9sOUE0qLTc8igunEn1WiyK589KNabl80
         iG2Bs6nuXJLhlLb68RNrtpqFJqm5OcxUd7AOmrF1EAIiBLkU+X5SOVEdUPtZyAn0wgnF
         UGfLmK52SOvdQ3e2H17L/tvapic/zBAIaWAHNcDDue+93vMHMMCCg4yTQijASHSF66HV
         gUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985929; x=1794590729;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        b=qMOOvMKN5EiM5BIc8CrdL32FMjFAEkeAVJPWsw9F5yXQS+FuJjiaLELej5BMl6vBpj
         JDNZWuv1OyiKXYRhnWIAPUXZaMRDhXP2zVcBzMioyqJEhgy/DsMAyAeMpFu9lw8+RVJA
         Wr1WBxcDaVypziFRrRixwyEwNskm5irgrTe/Nj/KWjpHoDU+Ll8xvyhkX/MQdelHHw/y
         uowadUvL2t1ZgoWFzELkZl6YuDl6rXgZHJGLM3SWPAxiLrdGF4Pu5irX48M5lcAQjWOa
         EgNKof5o1LWuqyHy2aCBnfGK1LLbStd0pbIDCoxkwMCtn7eIJYl1xO+FgZlFWch6OHzm
         OB1Q==
X-Forwarded-Encrypted: i=1; AKwUvByqwvSxXhkkARKMcT+j/rshZ3bBqRrwtyozzVn5QdzLI/uD3XdiEnidY0f2nXtke5ZTUTvdXvLgXQ==@kvack.org
X-Gm-Message-State: APuU4Z8/qgna+NCfwYNUMZYk7FsgqtPDH6jULwWKIumUvnMK/FCu2NI1
	Nv53brLfZwh4unuAURpAYHeux50rwoguzn8gUs87SOv/hyW9bDma3TpI1Cmli/PCebAbR6ON9mj
	51co2u3KLrUF0NP3+mGT3L5ic4MItwS6b7faZjAF4
X-Gm-Gg: AYBFou3sPHbVe0tXvvImoFX4gktPLEUMkppyJHryAUhpGHYdrmM2D5YDEebHV8PlQ0T
	sai97N+1DUCs4LKUFVuPUrnoSHfwLIXL8tJNm4mG23Ms5Ac/lKLNxt+WMnXwz9l6LLiWbk4jywH
	wcUjkcnGkOTKBVx9s2daOxql9N/WVZ8tEHf3qgZH286MJ5sZRD3EdkeVKTbxAP+0HVi+9KnyzJa
	K/zgja4T7Hy42QphsVRzcWIU+FDlRchWtz39tTLhZHdEt4uEAsJYSPpOeg23GgZjtbdzhE1Ntjk
	hbZESPbU+4fEHZlrZ4AG2Xo+Ld7bSyEFhMINXDgqzfIfR6M4RYQYOoB/1uslbTErw+BPWm/kVuj
	F9X7njp1+IHF+TS9eWNWhU7OvoIb8d1Iifi8wa9zNcJQWQUnJV6mTnKAl5H5QNw81AmidncL+cB
	sJVGC4Eo7N5wv/W5lQfecbCxyb8Q1W3v/oMGyJ05Ir1MjP
X-Received: by 2002:a05:600d:644f:20b0:4a2:a8c:22ae with SMTP id
 5b1f17b1804b1-4b78a315689mr14125e9.12.1793985928307; Fri, 06 Nov 2026
 09:25:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106131829.3228926-1-cui.tao@linux.dev> <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
In-Reply-To: <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 6 Nov 2026 09:25:16 -0800
X-Gm-Features: AclHuK_zmhBLd-fBLwMoqE-7QVB_DAT0nisVVyTe7VWHd67XlQDn1ECR61povKo
Message-ID: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, dgilbert@interlog.com, 
	mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com, 
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com, 
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com, 
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, 
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org, 
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org, 
	phasta@kernel.org, joro@8bytes.org, will@kernel.org, 
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, 
	mason@kernel.org, aesteve@redhat.com, harry@kernel.org, vbabka@suse.cz, 
	cuitao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k46h6mdwy7y33hgpzb3c3965dju8tn93
X-Rspamd-Queue-Id: 19AB780005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793985929-172319
X-HE-Meta: U2FsdGVkX185j8nOW8WtYEx2c2XnN7v41JKJj4DVJSlQtY5aYD771Rp8irL1yJkmlOrvoDNPCYNKtMhONQ6/t261hoD7B/qV8tO0YmT1GNE+B55O7d/DUT8HpUKXdQ400wdS3GEdntlDUmRixObIuBTdY4FiWIu8UEQGsLaX782AbU7mRZRYEwnlZB/mnWLhEiWf4Yr0fhbn4ijj5knHkNG3xGlan1hYfyuP8FVbAPFrlwgFoBuSkAX4IVHYEUzW/34dO8fTQqa1B0R4CaGu+cl79EYYWKKKppDMy91wC2xSYBwIr95t5/ExdUD3Av6UDXogdOg7nSAxRGT0CeAOzfTMUttUFnfCl/p+3/KG7FlI9/kfULUTFJWscHEL7uR9Hv98Ku5yDGvdTsvalaoBhiBVkn2g4KHtPdFbiQM2OdUqMJkZvxwNpdVLMVPVsGrHIjOIvtBjZClgXk/FWBdVbJ1domgvXcfdyamMnc1Pcmd3vVkzuEDY+fOruy90NEZEFZncyIeJJmomTjyVYbjX3hlMBD+2+UJeU1J+6puzk1CXq5Lf4uEeS6ftDKo+oi+aU6DZA7DCr4Elmh0dBvdwR/MKcFbdF5meebwGorux9Fu8Yj52it6cjq0Ndrb89KVbkxWJwTyZym9I5nydoZwMo9ppvGBpl/WNDJA2gOwjALwR1miYRFwSf8IALadk6Vjm01Hi/ILFt6xuFs9FCEZpI9lIUPN8NAnEbLtULQtG16xiIaUsLKN1cigOaEr6cCijVn2HtZodMDA4alHu/9GptJyjua+f7xWl7/KgjFfAgjghBZ8rTZ2tpOSKpR2w9b6Y27BtBXMB4gGu9P3X6Jge9LrXupI4YEgCMMi7QPWJ8eCL/cRgdXLXP7hA0xeErb0ylnrgU8JI3cDVYScQCTrblS5apGHutip8neuTgLFCARFYJD1Jcp4mxyeP4iWXhqKE4i3Z6XPuTuXAhOeYozq
 6+46E3i6
 9tPrDgCtWjghNEjjWNx+b/7gm2S/HL8fah4w3kTaohQDKYMlRlpUbUz1zC5RqKNs6opBwGmPzTM9/s8vvp2ajYHMYXoVL2DGrQ7wdGVB+gX32UOEQtlIs+aHV2Sfc5MRFQ9GunV3WBkRYOVHvxWRkRNoASr2/Cel3TkuZqFJ/Fjt0wIxJj1ZiyqUtOHE66wK725Znasv7eOJt6L0IOEZ9pVTL0zBP0rikZ2jW4Bzqg+lhfQ3dP2tlAo4tGmqvJeA6IGvKrZknYRXBCkFiY4/scK8CuFjyOK52L2vIhvFPaYNzAcwomD+lIdDv9TZbyMIwFL7bFVxIWfmIvBQwsl8s7zz9igkssSW3aLWT7hnEFtsuaD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 5:23=E2=80=AFAM Christian K=C3=B6nig <christian.koen=
ig@amd.com> wrote:
>
> On 11/6/26 14:18, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> >
> > udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
> > data pages keep the accounting of the memfd they were instantiated in,
> > but the bookkeeping around them does not: the page pointer array and
> > the pinned_folios array, both sized by the buffer page count, plus the
> > transient folios array sized by the memfd folio count, are plain
> > GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> > memory, and size_limit_mb defaults to INT_MAX.
> >
> > Charge the three kvmalloc allocations so the creator pays for the
> > metadata it induces.  The system heap in the same subsystem already
> > accounts its buffer allocation;

Only if the mem_accounting param is set to true. We (Android)
currently depend on it being disabled because system heap buffers
don't have a single owner for their entire lifetime (ownership often
changes immediately after they are allocated), and the kernel doesn't
have the ability to switch who is charged for the buffer memory quite
yet. Albert is working hard on it at the moment.

Could you update the message to note the mem_accounting param pls?

> > the data pages here stay with the
> > memfd.

memfd / udmabuf is a little special because it uses shmem for the
backing store, which is already tracked by memcg under all conditions
(except hugetlb). We don't currently use udmabuf, so the lack of memcg
charge transfer for udmabuf is not an issue. But once we get charge
transfer working for the system heap it'd be good to follow up with
udmabuf.

> T.J. needs to take a look here, but I fear that this might break uAPI.

Thanks for looping me in Christian. The buffer allocations cost
gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
so I don't expect charging them to break anyone. Leaving them
uncharged is an accounting gap though, since someone could spam many
udmabufs from the same memfd and only pay for the memfd pages once. So
this change is ok with me.

> A lot of the DMA-buf resources are intentionally not charged against memc=
g.
>
> Regards,
> Christian.
>
> >
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>

With the commit message updated to mention the mem_accounting param:
Reviewed-by: T.J. Mercier <tjmercier@google.com>

