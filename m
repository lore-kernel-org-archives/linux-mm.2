Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72808CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FEA6B008C; Fri, 12 Jun 2026 13:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE89D6B0092; Fri, 12 Jun 2026 13:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD926B0095; Fri, 12 Jun 2026 13:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEBB6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:08:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48B291C233A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:08:06 +0000 (UTC)
X-FDA: 84871893372.14.044F514
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70AAF160007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:08:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=idWB42RH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781284084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPeZaPzs0udTqN8U0AOdGBgcRR2p1XdQkPuDGe3FfyI=;
	b=aan+I1AUNxggsmQPPsIuSY9TCwM3jLXr/3jz77c9AKpFeY6oeSZBmZJmfwdDNLDWQq4FBX
	aDwoTv2j/I9XCohhPg/1a6TM2SxwhkDAH4rQl/u8ifOYEtveBI0QVWIJ0Y4ch3Uq60/1NP
	pkCbntKWp6zxT8HdgPY4Ox5UZ8PNGgc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=idWB42RH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781284084;
	b=0nMXFo/txtvPzj2WUNFDITdgqolQJl7QpBCYjdpR0Mm8u4zpHlMzcOVPs1RRyZdFtezeig
	mjyHllczQJ65i2KreMFrjsXWvObCeeYGvGQZ8pXyg2NxLjR0UCscb8g28AbeiK3gnqPdEw
	vNop86spbfeMI9CBL4r9uxHFe1+7rKY=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0b1a48855so3425ad.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781284083; x=1781888883; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HPeZaPzs0udTqN8U0AOdGBgcRR2p1XdQkPuDGe3FfyI=;
        b=idWB42RHZOqqiLXHNXT6pdKy0IIG9rF3VwcODjomSs3WHRE3l6zpTzI5FV8u16GvzQ
         yHDUQEDcUqV1gq+Mt3FFX00Ff/BWGiH3SvI9GpE/mDxYmcuGHSguer3bP/ayrGbLWpzW
         PNYSThd5HSIXBo3lVLhN1rjlpAhWtiCH+eyxG166DB0tYDfkqUQmAPW8wR9B7h+n3XjF
         9l4xZWMAqxINP+A9hAeIE7C0hrubA02OtCqsODpd0n/YdxxlM7LCd5cVILeBqgcG4CJh
         +MN4IVj5z0enXmjJ0SRRi3rYIo88FQO7jpaTqGMv9lmqaF9PL7jeevTv/H9coKQqkoI7
         2CRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781284083; x=1781888883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPeZaPzs0udTqN8U0AOdGBgcRR2p1XdQkPuDGe3FfyI=;
        b=MCcUrlSkDNF/MEEKUSaDwrmTySrneQKFoBb/q6NNdZec8P7o2WV/2XNQcyBtEFPNXI
         E302RszjKA7v22CWlLdpzBFQ/1hJncpf/8NansraOi2RQ1ZphDOPArnlA5BRRkt7nsH4
         agm2DgRkVFtCVkIiUJS8Mj0EN/6LS8H/ktY/TVctnCFWeyh9X8kyjSFA9KgMLkBisnTb
         VPowp/ty6sb2HJblQlNOuaPRqkccK63TtSCU+q5HQXVPyEtt8tsCClCDQdlgSwhERVO+
         I81dITkDSLWAPRtvdP9hDpaotnqtcv3FHyMvvufIhxlAcKAC7Iz1qPjLzLl/kws6Vduz
         TSfA==
X-Forwarded-Encrypted: i=1; AFNElJ/mgpN+DhuyQQ+5DLV646i8ELWuQwP3TNkCKBhwCGHa5qAxHwfjg+uOQU/+TExx0rlvhRlmpxRTHA==@kvack.org
X-Gm-Message-State: AOJu0Yxkoft15Dwjeh2eQAPqaPyl/4lGcDk8E0+aExJ6dTGCRknAUPgi
	8UBCxGe4Vr32HPOQh/Rs8K7W2kHtvJow3rjWwPVEqLdHfj2nAEH5Dyp5ZS/IppxkKg==
X-Gm-Gg: Acq92OFhYLSG/jBGhcYR4sf5cGU91KuUppcIjT0Otxerjjr7imMc7zESzZW1bLTHo7s
	Sz6/pYoIG141TvN/cJBOZsLDzMSsCkIuM7Z21YQKJrT0Ps9AByQftrgutPlOVmlwxraMkTIkULZ
	EjNKSMlkQ54gyu/xt2gHCR5HOY04f6aMIvgdk9oEx3pGO0pJoNaif7SlEiNQfJuAO3ARizkxWP4
	GXZP3GQo7xAdfQuBTOiSJfsWo7QR0qylDy5EppdZzdRN8hfrdLwbUUNRB0461N6WMaYdT0r/B5D
	6g4OOzOXQIyPYk1twQ0ep4FkM7uNusSs0rcl0BEo74tjwULvfAtUfPRP+/BeWLg/tKOTjOZIBno
	HgO7kMG3ENWjzVQIE24gq0+M/iaYcuAxC0rez8MKJ+Z0NF3d+BIOEwxUPzrgBfsodTF1CsKg3O3
	r3/DU0PVqReEQhwOaeYruGDZX+J1uFzBZTueP4WyjwjRYzEg5ALcgb60EJhlhvLSVJQqgFn3nDE
	Nm/ACj/UNhiNz1abqAFmUdT72hPEnA2SKkQgoibaXNVTQ==
X-Received: by 2002:a17:903:4407:b0:2bf:1153:54a0 with SMTP id d9443c01a7336-2c6651871abmr15805ad.23.1781284082627;
        Fri, 12 Jun 2026 10:08:02 -0700 (PDT)
Received: from google.com (112.174.16.34.bc.googleusercontent.com. [34.16.174.112])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42fbb5b79sm25331385ad.36.2026.06.12.10.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 10:08:01 -0700 (PDT)
Date: Fri, 12 Jun 2026 17:07:56 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Christian Brauner <christian@brauner.io>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Todd Kjos <tkjos@android.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <aiw87FbaIvYrSYDQ@google.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
 <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
 <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
 <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 70AAF160007
X-Stat-Signature: eczdg1omj6aeusubawrf9g4nffpz7319
X-HE-Tag: 1781284084-332999
X-HE-Meta: U2FsdGVkX1/3t1JrLYnOHsmYyom8s9kLnWDGSRQxmRweHWNVtUh4JVjJvw5UID81qwDa1OntZ5bzCjfRaL5pnPJfpjR3ut1fNNo6OjOMTE3D5XaCq1OAa/g7CfnEQ2VjQ1MpbLaN8O3yMPfV88/OBq6+pE54daMumfnbCIBXpzMAgaLDxHPy00ODieUtu78aEOXYOFn8h5Zme+iTKBPPSKZa80Tv27chuGWft5D5MxH7a0GJRY2jevKGika/i4/IVWLc/5huAGPi3XHTjVo4jgQAO2NFO06X8m/revM5iP4oy2hNDQq/pvHVEOPdJ9dr0XuQ51+iYev9q3wwEc5FBqXM+HoWAYAGFp7Z3obV5dImOkS0c6B2DkXbTzaeE0IcxH0cP72TUTcyzSXUJOvTWdCZ8uOURT3u2Bp9ZuI4dFZSYnfFf++3BSskI67apSFtQogUy6VVVdrFhxW5uSL2VkNWHKEBuHUEprVI8dKO2UslKLeFk8tw7h8PkkkutN8XEyCXRps3YUrIjEa11pKOLUTieg7VLc4E+EVl0y7+MErLQ3ZUDgLlSGd/xXX+H9TnBW0GHACtq2RrIGuiqDQSIgRyx+J2TV3zW8I70AyYZ0q5a3viEDg/d+6k9U1zozdlX1MWnoNPfrVcsTpz4KS36iaLqBI2bLjLEG4Yz31bxFyohkoiGf2mGkVKNW8ZdeSCWJPBoYB3wUdXXTnhDVmsHQgfhsoT8f2R3mY/nKyroXkdjE7gShdY/kO1C6uIZkGO0Z7Jid3P7eqOPMkwayaXeLRGgaBIAPjl8ziC1yWrjHBfFZQu0b5Rxppd90VqYSDv6h55123Iqym0WI9kQTYPW+tDs/RJkZ+W48XBINcDH7lKQyqDwlHUxp3XStRnL8phzedRaUbRCLVR8guMCt/PGWiEWOQWxiv+Rb5GUdsBARPTNHukjaa0AAyE0VvyY3diq7i2raSWBNc8DGJO2RG
 M+F4WV+Z
 uprsPJkNSJwon38qIN8YeWaf5mNByYkaALCQZEoNBJMzF5akPk5anll+KW17gMVPtC33pLJcpXzpi+usdcu48X6QPcbn+MC7ec+q79JmTJdwcBrkFhl5uapk0Xivujjr5k0Q6jbboSo/RAKpyDvNyIuKsoTWv5InlMmsxXSZ24B1ZjZxpguEcNFJjFWKhY73Xckx101bqDZtFjkrCNI/JyZHdYrDG0RncwScujNSvzRZUJshyoO5WaXCE18D68Lq4pPkvnclgj8jcnOjnhc9HJ+KkUubf48yCye1eA5EEKekzipIblCXcQqam2aonvCS6w2wSKya9i/hn9eF7cI+qgVNrgGLErrjh6WJ8ZjViYjKSwva3PwHlVdf4qu6yBSEYLI/u3JcjJe132hKyeUhuNai5SNI3ZVuTsLlgxdFcimui93m5344T+7W+pps0lklIVaML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 09:54:58AM -0700, Dave Hansen wrote:
> On 6/12/26 09:41, Suren Baghdasaryan wrote:
> >> I think the key to distinguishing between:
> >>
> >>         vma==NULL because there's no VMA
> >> and
> >>         vma==NULL because of a trylock failure
> >>
> >> is binder_alloc_is_mapped(). It won't return false until vm_ops->close()
> >> finishes. vm_ops->close() shouldn't be able to happen while
> >> lock_vma_under_rcu() is held. So if you've got a non-NULL VMA, you've
> >> also got a stable is binder_alloc_is_mapped().
> > By "stable binder_alloc_is_mapped()" do you mean it would always be
> > true?
> 
> By stable, I meant that it can't change.
> 
> 	vma = lock_vma_under_rcu()
> 	mapped = binder_alloc_is_mapped();
> 	<window>
> 	vma_end_read(vma);
> 
> During <window> it can't go from true=>false or false=>true.
> 
> false=>true never happens from what I can tell. It's just plain
> impossible given the current code.
> 
> true=>false is locked out because when lock_vma_under_rcu() is held.
> 
> > Asking because in your patch you removed this condition:
> > 
> > -         if (vma && !binder_alloc_is_mapped(alloc))
> > -                  goto err_invalid_vma;
> > 
> > So, previously if we found the VMA but binder_alloc_is_mapped()==false
> > we would bail out and now we don't. Are you reasoning that this
> > combination is impossible?
> 
> It's not impossible, but I do think it is irrelevant. Or at least that
> the *VMA* is irrelevant in this case. binder_alloc_is_mapped()==false
> means that the binder VMA is gone. It's not in the maple tree, and it's
> not coming back. If a VMA is found, it's an impostor.
> 
> That's why I did:
> 
> -        if (vma) {
> +        if (mapped) {
> 
> The question isn't whether a VMA was found. The question is whether the
> binder VMA is still mapped at page_addr. *That* is best inferred from
> binder_alloc_is_mapped(), not the VMA lookup.
> 
> At least that's what I decided after staring at it for far too long.

Yes, I _think_ binder_alloc_is_mapped() can help distinguish between the
two scenarios (contention vs vma-close). However, I think it would be
simpler and safe to do an early exit:

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 88c3e1667d5b..9dd7d927249d 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1149,6 +1149,8 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	 * for 'page_addr'.
 	 */
 	vma = lock_vma_under_rcu(mm, page_addr);
+	if (!vma && binder_alloc_is_mapped(alloc))
+		goto err_vma_lock_failed;
 
 	if (!mutex_trylock(&alloc->mutex))
 		goto err_get_alloc_mutex_failed;

