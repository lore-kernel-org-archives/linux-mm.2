Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D28606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mhb+xqFx
Received: by kanga.kvack.org (Postfix)
	id 8D7A16B05B0; Wed, 11 Nov 2026 17:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888636B05B1; Wed, 11 Nov 2026 17:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751D36B05B2; Wed, 11 Nov 2026 17:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47D056B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:10:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF078A7FC3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:10:29 +0000 (UTC)
X-FDA: 85424232978.16.EF54EC2
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id BDC35160007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:10:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mhb+xqFx;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794435027;
	b=q/sXgkP2+zMjGBzFBe66MeVBzmgpnIsLtCR2ShKY0aCEJhXvMdUASx5TLEKiFSvQdEIzMa
	q2GQjlPMWSp1sWwsepiOfDNPVOJfIbQ6b9SlUsoCFt98y736Y+L2mAa0UyF888c8Cew5+O
	wqZxfLH9a29ZiGEfTS1zGWDnNMMGj9k=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mhb+xqFx;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794435027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLKfpDlOWEozQoVsuZM54f6sj9dITZwkN+hPeWugxEc=;
	b=e83z74AbR8W6NZzJMx1YQV7nIcmPzlfjaXRg4ZuFqqJ0+MOg9J5YnyeEtX+nOwu5rts2ni
	/r15nz+68jvTUDveow4rOwzrgBz5KSJfV7QCCvMHfPvXe4mXT1baFmoC9uKmT2nvjWNE+w
	PtvLTwVTgwqpOn+ythGvuA1W8N8W5vY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-535f598d126so18561cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:10:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794435027; cv=none;
        d=google.com; s=arc-20260327;
        b=Q1n131Mgkxh9sPI6xNXR3ky7GSu1rWg6ALiY+9PFn6O8u4irua1PyL8shVN0qPWPSu
         INvO8ndI0gKE1SfdF2CkLiousahq5jKRBYWm84ANasJxreXf+IIAKZuQk9QQTQdReRY5
         6XLqPcE4mq7TIjFcapoTtiTsYPVhOIG6P5ePo1KoIU7YkXh7PXoUmnTIlLXov3hyoamC
         xXzpCDCxDw6ZfHiWffppjUTCK26UJnFV/45cV1GawquS1IiD7bVpxx9e1FJBazdFvDeo
         80MCCKifieBByGhxTdjB62zTnIwZYbh84yWtbrFeYiM7cluCnf2PyPPflaHW0xd8WGy2
         xUtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bLKfpDlOWEozQoVsuZM54f6sj9dITZwkN+hPeWugxEc=;
        fh=Q0W6DuQQnoD1KjY8E3Nt6asIZxor7ySc/oNsVRnaYlM=;
        b=l+eiukbiPQ48LJMdQkELrsua3ikqEjzyxs+MUFF/hrKdhYBVuqo3jcmtPnMhmM9897
         SokeGUKhRANbCE3VbdM2lPeLYjjGZeJxJe4EFLhdj8r8k65zfYuwqhazJDM/xHjVL6pM
         3T2cGmCk9B+kdmYpKTgadPaas7gspqEmizVAOmcNMcGglpNXSTqKoX/JWLgJBhu3oMDj
         i1+6qHg1yvfqPJz+GJ+2eXipeV/ulnTXXobdsh38LBAIXcInGXu3ns7ZlFTRcUv6kXIn
         UIGFIST3IFe06WM2EicK70wo/vp89ZfkIppGOHzcyDTFXqVW1sX6nYSXvSYCOjtSj4Os
         BIRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794435027; x=1795039827; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bLKfpDlOWEozQoVsuZM54f6sj9dITZwkN+hPeWugxEc=;
        b=mhb+xqFxVs6u+851y97IhLZYxbyb/pnAd81+QXf0SgGaTwLvN/Q5/kv8eqCoqfZRDw
         dJC0kcny0jnm/I/EUSMjsN/5owd922frucFqMXUo6jCPDWqnHfErsNmcSp5QJdE4dQpf
         3S9fZFMM4TU57cm/dnN3kFiSOKHZHa1XpkI4Tr+HAL/Ohs5UgX7SCmnLI6OdpnCICYi7
         DtlSWk/ie12FCYB0sGcJMhykbEYVCMPij64lk+LPU3EMgfYpXDlI8BebWUtkn+wamlbh
         JJIMfOPazBDs45a2s/g3GbPhxuLtXwvzDKAJCDJfZ3fs7Jl6fVdvwOMT8Z6c9ell3sDE
         PCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794435027; x=1795039827;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLKfpDlOWEozQoVsuZM54f6sj9dITZwkN+hPeWugxEc=;
        b=OoEMH2hwg8iJTjn0YiUJp7YOhjLzT/LFy2RPUd3kkynJyn07jhhVRPTN2j09QxHWUi
         OEiU057prX2p0fpASTvGYiR+DxDAxP+0uc1VOgHUwcLR01AjhrGjRM/r853jIYMZvT36
         WwCR9KikbnKsm9YKEz8LJ1F58E5Rf2zPc208RPwNaBELUcJPUuqlBG1B392VczS3pqXb
         hxbawMEceQuOvte9IbTMCb21MIuu149/ERVOTqf0QieOBCo0YAhymsKV6A/yGHbe3Q2I
         aMwm2eUXrEIXziggVaMzrzTSJIROD33Wt8omOtehrcC8QYWz2Kh1x3xAhvzD2ifQg8/m
         JhXg==
X-Forwarded-Encrypted: i=1; AL+hErEU8dGjiJheUvHC2fcZXyQ/RwhS3NQsK3ZuH6pdbd3f2eZLjO2+OJmNFu79eAadu9ukwy+ynVW/aA==@kvack.org
X-Gm-Message-State: APuU4Z8/IqBjy+nBJlHxRvWPL/8KDQp/A/+ib7/oMxaORPjsypypMF/o
	Yre80wKmTGZpYvmvzEkhYC2UGooIXxyouqCknMjngcqYu7PyTnY8ZbU8qLddojTzzQ2xJEjbKXC
	y3n1YXyNuhptVE/YVbSEGvSdkFCLIno0CZxZTiKx4
X-Gm-Gg: AYBFou1/Ba/lwAbw1dPK00L1BHMkM/qsebitTgnGq8R4mdp/QPG1xVIe4hw/BwfUqbl
	I/i8JdIk/DlZasrdiQLMUF6fpDT/jL9IbF54xYIXHcyYNYADwzhAQst18jETfc4h6qmIQF8LDsX
	TLz6neu5akS8GcKzkAh26wT3RjyGfbLRdbK+OnnP6a9skqlDjuUGQVHsu6mVpP9z7+RFGk0WyiF
	dKxj0ZypBViAJ+Zn0vDStIESDCSI349oWZCyWSxQnQaLhtMQpy6k9aIkFo//b83DUEJtj2SLTdU
	GoAZf8vfktZsxdfeSgaVipJh1IYM4E+EPbtk+9v3EDKv8TBzQz9WP9TZQCKoGPXmhoQ0soJSRQU
	K2cVo0AzHPcCdFuhxQyyI6ijN75U0MMCGDT4TCS40uLVDdg1hJBX5B3RH73TxeD6mMxunLUb/Kl
	BnkqB40ITsMYwDZbiLYsQSQe27E2TsJg6F9eefnULPSu/36Q==
X-Received: by 2002:ac8:5c84:0:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-5598d505571mr2244351cf.9.1794435026089; Wed, 11 Nov 2026
 14:10:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-3-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 11 Nov 2026 22:10:14 +0000
X-Gm-Features: AclHuK_l3jxTpbDz5cj0MqeD6GMw7HTTKbt-o4s7KQ1Qky5aunw_Bq-cT2pqqvA
Message-ID: <CAJuCfpHneeqRFOXyzCPPPa66xfn7Oa1n5m2N67o_pVwJfNgeXg@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BDC35160007
X-Stat-Signature: 6bgyfpb7g1hxjxexb9rkmimkxx9m8331
X-Rspam-User: 
X-HE-Tag: 1794435027-17835
X-HE-Meta: U2FsdGVkX1+LxH/XRbeV52ZqeUVGr8DaSr9XugGkIDX8Yu0EqnAMny4F/77RtJJNkGXKhs7Z8754jutX6OWZD71VYi/o5nbtTwz30eyn0J9oy2o5WZCfBELBwaoPCCUiuK4XiiYUDY+XGsnG7lbKWgAjv9HK9urhR96kpOJeGCb5R5g51jc2yS4/jkc230tU6K67pdZS0cKkVsR1WpIadkZ8PwL/xnbmqXSmfG+20s2ECNrwfIvT8TJ4q/K1+/abXU7fvLLz5osDYjPDPiLZ3oDVYu+upr4rGG5wOmx1A/RqcKhgLOKyJnuIv2aMZ8RcH/vV/V/tq90euJFq78yyQsYaiEVnVSF1MtZgUjX+j7g2f6vvG8BaIC3uPf0h6IhaaVIl5somb68v6pNh2uhGgQXPLMckVEkyzjp7ttR4pZrKfbDd40kT4I7Sagr1njvwo9SAgyA54U/K+7m1ki7JLnDh5ADFDJoNSHJEAhZ3ZEyQHdJo5s9Htmh/DidE3N3o+FqGgXS21rmi9Jg95sCyaQCbIHxv8ppn2oqVxAqtjHOQtP/yyMq1FJ+1sjjavl5Ou2vhNTsBd/INtf67lAipPK1+vbz5hSdLFh8C7XgdzLQieS5iZyGPCXB4EWMHRtTRl0jR53Mt3D1t8Mz98e8HEFo+P2MQjgMNZYBgI/JbiiVqDB9hqj/Lg9eLZGtrv9aJ4AKjlTGTfYFrVhZgfcx1I6ipFUQc3X0BcxpCpf4sLEYDNvSAxgEKfsBNNwK0C0MYOwCrrf1O8dkriUXE4940ZodxKwIWAiFdo5k/9NxEY7awwwu9M1sWizJDGn7cfN+TSGCAuCt6SLGGk9+8cpQ1WbC/cKXFfxvS25N4uHeuhvGoB7kbXVMsJZNi9GyAtEstgKevZmiaz2GbwZwIzh5viEB8Omqd61J5ePapHxhUO0D2MAeLcH4UXfRnd2t9heb47Z64S/lKQd6+FQkh3T3
 Iq008auq
 pFVypAF861u7Nida+zj8XFxFS3QAvdDFYZCG4IhuhumSYkvR77ZhKip5TVUSyb5IG5xum/HKVt1KJ8orkiv00x5UNuaUWrico5NAfJxqRCNMubAt67kZSgC1vnNRNQfOM5wlwMRTzqWSIGzVlo28m/ArIOzTLGQr/mWaHHaytV3vrL2T+NJWSlMfKEIn61kkB4AurWAeaWui7oaB2Efxh+3KDLYNdPKvik2cDYYZwmEBpxfVOc+Vo4eQxhe22JM4+SUaedkukKCiHlwqcX8PzQmubhNMhJ/YNFg+gF2InolacigH1PZgW8MM5GO2jR99jpGS+IypHT6w0JC7jarqE1fzBkuDzI+rap2I6sajaT43mpR71bqGgQD0C6Xd/Yxr24WXqvJ79vH/2L3mXWqS4H2x1Vq75csm3zYCT7/lcMzkWGc77i0d3j3/LTAaW1V8+2UkE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:24=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
> false.  The unmap side does not, so it still walks the shadow and
> origin page tables even though KMSAN never installed any metadata
> there.

Note that KMSAN_WARN_ON() can reset kmsan_enabled flag, so the fact
that it's false does not mean that metadata was never installed. I
think a proper bailout should depend on CONFIG_KMSAN, not on
kmsan_enabled.

>
> Add the matching early return.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/kmsan/hooks.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index a706666db097..107f66841274 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long add=
r)
>
>  void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> +       if (!kmsan_enabled)
> +               return;
> +
>         __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end)=
);
>         __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end)=
);
>         flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
> --
> 2.25.1
>

