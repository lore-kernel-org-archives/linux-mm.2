Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA9160A5BDC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iY/Zo9i/
Received: by kanga.kvack.org (Postfix)
	id 7DB786B061E; Thu, 12 Nov 2026 17:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3086B0620; Thu, 12 Nov 2026 17:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3AF6B0621; Thu, 12 Nov 2026 17:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40FF96B061E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:59:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE25B160E04
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:59:28 +0000 (UTC)
X-FDA: 85427985216.28.1CFA959
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7CA020002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:59:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="iY/Zo9i/";
	spf=pass (imf13.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsSjLqJE2zg5KnRT+r/w8Y0ianrVtar664vxU/qkfmw=;
	b=z09H+bQFQ9Xz6ys+53WaKnY3u3GCAen1Vea60YQ8y3tvrRLh2u5bCPzuPeL5LlaJiznoRq
	bnLbGT2hBmZNuqGCoVSpZ+K9y7DkasfIRpV6zBUqA7lM6Gn/Tts0TPYDN9qpRhBfTB7y/e
	Bpxknqkx23fbfY5zu3QX8V89o12ES0o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794524366;
	b=N2kP3Of+PQiazvYVAAgYadLv4ovBbBlrBUeydphvTJam/QmwqZccJgRh9AbXUGVzZeLuaq
	laraEdCtGbfVEI+gUtq8EEljFYs/FPRWDfLWgTdq3bfSq+X5S8UPqlWq4n8kJGMahoFI88
	9b+XZ3wtMk5UNrCOIiXQCCTe27kiA4I=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="iY/Zo9i/";
	spf=pass (imf13.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-54492d8a988so14581cf.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:59:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794524366; cv=none;
        d=google.com; s=arc-20260327;
        b=kVViSx5sCoRiT4/WmCJCoB7ZnMoHqUioPLfEN7b62hQuXTo3gz2JJcc54d6itJcTST
         oRKhW3TKYfpBe99MqGUDNHNRDq+xnPufjXph+TgHtN8jKEcL7O2PD40TWlyg8mhKpNYH
         wB2z0rhjene2aeCMvrvoWuUBjKb4IYVrH81kP0vdNUxl/qJZCsCgPlfKAyfDjonT4Eq5
         E3qI6gf7AYVG8ZnfXFd3hmovYh6xYviAS68Vp/Bkaudv6MCFaioDhivGbc1gQv0OPwOy
         Q8KXI2A1OG8AC8Whh65J+W07Bnb1OYbmIZPe2P4GB/bThHiWNaUhv/3zHswuZ9scByrj
         3Kww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZsSjLqJE2zg5KnRT+r/w8Y0ianrVtar664vxU/qkfmw=;
        fh=kC1rgMKQ6ltjQPTyGGoknAFLgNJD2G2wYpzOnbV/sqk=;
        b=XJQudIwhVIQBFX4KzOWkvDFJGAypp4DG2uB0s1Ruk6A+rueRKKnsBX0YkfmJ8i1xvG
         tJUqXLHsZDCM7zBPDEZGYZ1OdLHfuShdPO7PJpJQ/7KrLk6XxCgSTabOdt55/TCFKIO8
         SOsDL5fcZLPPm87PW5uDdU0XFRK15wCxmCuB8pX2xx8AaMSwZ8xkVgE623v5kozbj35V
         q/TFqHxeQoobhM/MdpQj7EY82lVzeIJImSk42n7QKq0+hWq71voJDXHantsvfbtYEVJx
         6ykQ00VhtIYR3WuDjxqUEbhJG4hiHhsZX4Rhz/rSXSfzGw3JJq7GSgapTLWFKnbzKqhK
         r9HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794524366; x=1795129166; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZsSjLqJE2zg5KnRT+r/w8Y0ianrVtar664vxU/qkfmw=;
        b=iY/Zo9i/VEeJCr5kLAW90QVc5hPV46bWn5l/Eu/v2/1iLKgRZBaNEZgLKFg2tm8kFq
         UFB8ncBUj0GeHkjKH35zrTcaDPweFUn/TMmrPG0Lw4QOPw7chIjobcD4yljPNEs96B+w
         TKY2I0QBAKWB6VMbCXIOijOekrGRre2pnvuv5x9sLzRUq9G6Fyv1gatf8ng53zy0xcnn
         UkEDc1udeoz+MYthCrVd7lus2rL5Das8EzRJ7u8TJSxcERTNBBVt0SvY5EKcA52NnlRA
         aOWoZEH5Hogy5rQn5MAGwlTxpkfqAbZX2YOFIrJyRg1YWYLcf+ICTUkUJwinvcTD/g7c
         oaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794524366; x=1795129166;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZsSjLqJE2zg5KnRT+r/w8Y0ianrVtar664vxU/qkfmw=;
        b=hKu59+23/wy0R2iTfMDg447Nb7QX9DPHJLkpx7KAeAlP8bnDxqxBaK4BnjbopjZb0e
         0ZYSIrsVRrWKFNXqgHQGCN49y0u6T3tkZ8WfYDbnL7O7zKPdmVQFddw8t8Vs4oSydDV4
         j8s0pKtWauePYFXL6qzNDSsC2jmqJ9oAeYeIbEAU45B2Njf1peFqRJxlEn0Z3G+orRgK
         7sq8Xb55eKmoaLIRtiR1i6bvGLQtU1EeCCvGoouoNZg53ZMAsCKEWoXBMVRAtVUXHL4u
         FsF26eMCkhtEuVNqK2rgxeUmcdCVcDWqg/rcSnVQcXhHUMuKXIaF/nWxkhkH2h3Hjtut
         Du7A==
X-Forwarded-Encrypted: i=1; AL+hErExnmwgvWY72ZuonouF4yzcwA2LV1WQI++RtK2dvSKUzgnpO5NUvHnuLuO2IhPiuMQgQjiplx0I/g==@kvack.org
X-Gm-Message-State: APuU4Z8kJWVMs6urtr1BSfdLmfFXiAXzy3d/kQHA17ikZwXn/SDRMbz3
	F43Jxz5cMj992eB6bosRh9H+O1Q2VgkTwtAg+tFu8ICnBjkZnS0R32CUs4MhkbRCSGiB69Nbk+y
	WUxG4B5Js8BxCyGeiGQVLi8YXrfJmusQ/cD5LUYNp
X-Gm-Gg: AYBFou3725Tt+WyJfdMsveSCzDy6LEKIgR8L2Snrx86XSzexo/dNOAU3pxJM5bOx5Ce
	CqE/HGbJVdZB8YnY8R2/sux2iKcNMAgEWAXH9UwChCAhIL5iHYCp3x3xtw4qonVMD32z6B1Zhhg
	e6mKprNgm089vEwXHiqlBTSnnu+pRz/dEvXE/hnUMa4Sk1FeulORDXe6vn/bt/pO7LkpkJHJrsN
	9i5Pq9+YBYTshkrBErOXdq2xS6iSAj97bdiDv/CmN3Wjcd3UBTyHKZwayJPzIwqoeEbXTn4GS80
	CTww9P71msMmAGeo9JqnshOHq+4+o0wsCmwZACN/Y2Xxok3Ejvq4jKSW9KRr6P/93URjIfLxqI6
	nWMghp39ylPKq+7DkGdM4POT75e8QVHtUgXBvD4BQxw8b/07zkrK34bf+VORXdGaqAZM=
X-Received: by 2002:a05:622a:98c:b0:532:eff9:ca08 with SMTP id
 d75a77b69052e-55afcbede04mr2871271cf.12.1794524364998; Thu, 12 Nov 2026
 14:59:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103223025.2482227-1-nhuhuan@google.com> <20261106085019.90487-1-lizhe.67@bytedance.com>
In-Reply-To: <20261106085019.90487-1-lizhe.67@bytedance.com>
From: Huan Nguyen <nhuhuan@google.com>
Date: Thu, 12 Nov 2026 14:58:48 -0800
X-Gm-Features: AclHuK_MjdqInx2d6Ru3Fw1h0wqnaU6otNi9RKFyMPSDK4f5OfZNd4Zh3wXDlV8
Message-ID: <CALwWd5tttbaNWoaXnPZjHFgYhG8yMyT67_9nhRKN336EHOVhqg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] mm: use non-temporal stores for demotion
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	alirad.malek@zptcorp.com, anna@kernel.org, apopple@nvidia.com, 
	bharata@amd.com, bp@alien8.de, byungchul@sk.com, dave.hansen@linux.intel.com, 
	dave@stgolabs.net, david@kernel.org, dimitrios.palyvos@zptcorp.com, 
	fvdl@google.com, gourry@gourry.net, hannes@cmpxchg.org, hpa@zytor.com, 
	jackmanb@google.com, jic23@kernel.org, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, mingo@redhat.com, nifan.cxl@gmail.com, rakie.kim@sk.com, 
	rientjes@google.com, rkodsara@amd.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sj@kernel.org, surenb@google.com, 
	tglx@kernel.org, trondmy@kernel.org, vbabka@kernel.org, weixugc@google.com, 
	x86@kernel.org, xuezhengchu@huawei.com, yiannis.nikolakop@gmail.com, 
	yiannis@zptcorp.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7CA020002
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: s5u6z7z957i7jam8nzixw71cp3b9oy9x
X-Rspam-User: 
X-HE-Tag: 1794524366-459332
X-HE-Meta: U2FsdGVkX19XgciFJehekjbUq4rPDbHU2BUZhgzzHT4XMOWjdsyR6AVKNdv1NihDr6kTepxg5xcqrWUOT2pB1zezNy2JTMy+Y5xq+gNkjTzPy5LJzXAJ7akpFTTQMB7Nc3RZ/nX3IjvxB4u+7L3mnkPlbs+bW2RG3Mn0EUeC41A+li4H9iW+bdbqDU+RsDj4+K8VLPYTxhJq7QPHTpGkq1TIaDR/8EWPhc+rqGwQOZQToynEaJSmanOF6oEc0xoGkvtoymlKVidaTqX1szQ5dZIRiMJGR3qFrrDE+P3zTdg0UNqbF14+ElhFDAdcJCM2/i7298S4E8rnIXHni3sUSX4cUcoL2E27M8E+nEqX1jJ9dePWFb0MMGOewbv7aGrQrVQZbIYEnOoCcyCIRNtlB6HFiXU5x2QnfxM+HyhD+lhzLynnaqVBK79xoAdmKkxhn7kf0GTmd1xlX+/6ocvCzilFvN0vh4v6KPr/nJYXvuC9r2jHVbfZGUVXgStKTBsehsrMII4Mks8xK7HC9cytlp7jgOZiL3g93Rdm/iLpUMHuJXAIfA9/u/yz7I6rJvhZ21pQO5k5ObdJkI68/LszQ2f2JWeYa6bKnkfgXy1Lz5uVia5hbzHAvOVWGAn5VUI2WwNb5BeaU8gdT0n/rWEH8LALn+SMWRLnnccIsc6Jjae8yjo0RrZ4xw5WgJ2ODhmUbg7Nbutujm1ERc7FsLw4p4FW1Qqq3BGkrZI+8ObijakKCyRU9zh/1Cwpgd4ZlrwbvMqSlD6dCmxD1muSt0+RjCrHzNiL8H2/nP6LTIKI5+SIphfGAAMeB/0QLWyT0L0bTQj74Cr5WX1oRAvRYPDFu9HdV8dLDh/7wYm+N32u6faOJa88f0UymiPHE6FVD0ANVkx15IQkdDxiKaF7MyvbKUtYmqt62SxDyERO9U89Epoo266r5E6c5nsY3Ip5r4gAv5lTiMANL/pXbnUDv70
 0/3fa73I
 JFDOdzCg5jZBXuTurUzP3LQLZ5z/eponsSGf7haIZU6YLkn5Y3Xj1txNt/coEomd2atZdz1tCPJ+OBPITzAbZflzp4HS9KMhC5EPpnNbFdcE13v0/BgdXOwHd7QFLt104TrfyKshr59+UqskwNXJbjjaXi9lXbQXNvzKaEQOGFAr0L4CC1ZalwX2V/Xj9ZBxpOW3wGE+IDVQHv4NNP7q1Rm92Poeurb8Z7oYwdk89v2WbsVxcsnvnTErfL0u1IbNONsobTQUpcS9nED26Rs/PjoWFT480Emuma9rcyaax9OFIdO0XNP1rYFMe2cMYcVJNHjrxooWUwRI2gx1vOc1tGFpqlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 12:51=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com> wro=
te:
>
> On Tue, 3 Nov 2026 14:30:22 -0800, Huan Nguyen wrote:
>
> > Using non-temporal stores and prefetching on x86 bypasses CPU cache
> > allocation, protecting active workload working sets and improving
> > demotion throughput.
>
> Could you show some real workload numbers for this? I am wondering
> whether the reduced cache allocation and improved demotion throughput
> also translate into visible application-level benefits.

I do not have direct benchmark numbers for non-temporal demotion with
this implementation yet. As far as I know, Alirad and Yiannis (cc'd)
are currently evaluating its real-workload impact and may share
results once available.

>
> > - Memory ordering:
> >   Add a wmb() barrier at the end of folio_mc_copy_nt() to ensure weakly
> >   ordered non-temporal stores are drained before page tables are update=
d.
>
> I have not looked into all the details here, so I may be missing
> something. But before migration completes, there should eventually be a
> publication step that makes the new folio visible. In theory, that
> publication step should already provide the required ordering before
> userspace can observe the new folio. So I wonder whether the wmb() in
> folio_mc_copy_nt() is really needed here.

On weakly-ordered architectures like arm64, the publication step
indeed provides the required ordering, because smp_wmb() and
smp_store_release() emit real hardware barriers before the new folio
becomes visible.

On x86_64, however, those primitives compile down to a compiler
barrier() with no CPU instructions, since x86 assumes TSO. Because
movnti bypasses TSO, the standard publication barriers do not order
non-temporal writes on x86_64, which is why folio_mc_copy_nt() needs
an explicit wmb() at the end.

Right now __HAVE_ARCH_COPY_PAGE_NT is only defined on x86_64, so that
the wmb() is effectively x86-only today. If another architecture
implements __HAVE_ARCH_COPY_PAGE_NT in the future, we can move the
wmb() into an x86-specific scope in v4 so weakly-ordered architectures
do not pay for an unnecessary barrier.

>
> Thanks,
> Zhe

