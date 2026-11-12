Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B18606A235
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=halVOeT/
Received: by kanga.kvack.org (Postfix)
	id A34816B05BF; Thu, 12 Nov 2026 12:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C066B05C0; Thu, 12 Nov 2026 12:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDDB6B05C1; Thu, 12 Nov 2026 12:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 624A16B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:37:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17FE0C0664
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:37:12 +0000 (UTC)
X-FDA: 85427173104.07.3829D5D
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id D2CA01C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:37:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="halVOeT/";
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVq19U8dsLUULl5Arm+uFElP0L4F8s4K16OEcmVJkjM=;
	b=ytFxdVlsd0zL02ekrilC0gEA/1/zoT2/VtFDjCTEuxyCc7emgD57TLN+leHiyC5HfqNIIU
	/F8zTgHEK8k1DHAW20NOf9BJW2yeV3lRdJTsZi7kVUeeY+XYW4VasSQXVtDo6z7K2q7JPb
	w7rkDydTU4SxlTm7EY6Hvhqub/SHtOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794505030;
	b=hjdvYz1p4aC7VhFNH0+LaLBFILUOntpLSzprsIZHEtRDt+mxqF/rijEGYQZTnMpP5F/jxe
	1mGHZk6y5pte5i0MOcbfCs4Pu2+T4zRfDMRw6g+OuGO3C2uXKbnU/QEi8y8UoP2Kkm1PEM
	/ILwUQW4dlfgBu20pGNfV5Aq+BjffYA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="halVOeT/";
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c148d4dbfbso81790e87.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794505028; x=1795109828; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AVq19U8dsLUULl5Arm+uFElP0L4F8s4K16OEcmVJkjM=;
        b=halVOeT/z8IkS+uncN4GOXhhtHlXXyLPcBrN6vaRG+uVuieYL5HSGXyFltUUqzV143
         7oF2ehQrTtvoixiubBAgKLg3jJMn6soXJwiAxoXdpW2nMpqOh2ZGnq5Cu50JFRO3ud7d
         FwO5KEg6z1sWwewmcSHN0ZHHrHPHrTTjPVY/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794505028; x=1795109828;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AVq19U8dsLUULl5Arm+uFElP0L4F8s4K16OEcmVJkjM=;
        b=evDm/x8WqiuVTu2iMnL5+afK0LSqucDx4By2mNs7HnsMmSwphli9yrDH78A97gerU9
         QX0CwM0DjT4bs8yVBT0KMEoww5I8MHdJdz033WaxrBzFGZNv1mBLK/8qp/e05oWpIFnW
         uFdv1ZCvYog/WyWCibpC7Pp1hlRkZxFPtEuTNsKOyfmpvTrKrVn2xTH0mLO8qo01Wri5
         LXmaXXOOVO5G4aI2/RTPE/r9BLWxg0cnPn6BUOPdi3V+LFw4M5GlrITmJyewsK08Cf1i
         M3QseMVofyMngbNTsVI5hcFN5zBIlkX5ce2gXjNsMcGYtoseQWg95HtqAM5hyfzG+B4l
         1YRg==
X-Forwarded-Encrypted: i=1; AL+hErHUBfREcsikgRIGjHdtcqcbrAm7RT3myV5hosAlPCWF2KrmUz1HmxbFv5eI9vd6XrUQVg51rUhX1A==@kvack.org
X-Gm-Message-State: APuU4Z83NX6gqydP+Iaw+XHRKUqSuLBwsE3Lm/03P11tni+BCK9ZX/AJ
	ghPwHhaxAujbXjPiw8oSCe1OQaGWksmW2+g4nQ1gCTrzytL6xyC/KwoJgLj/wAXrXaW6LKKnQhK
	EYsozXmw7DA==
X-Gm-Gg: AYBFou1M7xaPITV7+zZHG+Jtkqd/Sfv3indYlmf7vTygqXxJoGVvaCVfhpvw9W6p/Sn
	v3PIfywOJxgXduf4FR8Vr02lXmBn+L/KkyzMeePnHBmaa9KQspmmSlMNdR4nGzMm+ba7LpmBPdV
	Wp3EFyNvS94cOw4FtBsDxSLQ0vCO97IfyNrxm00JIRp+GFIX9B8SSdHxk8cEbKjVhzRRZXMNwMz
	tV5nNe6xIat53fCVI/gcwSJSrTQcRB+6J7SWDgMyu19s3tNQR0KgOkXx+vGm2qarsfPsmAVPCu9
	FEQVQCCtkMRxgk5obeBKjWfOtrTeXejoWwN30KZ++ayi2PsPG5J/UXkGpAoNBfgOx5zY60SKPMM
	0uaUX7IE7Re1youyKyxciCnCaLX4gzmsOcycATZYE8nFRMzHCM/0uVV9V718/mmsNB3zcMbkO1E
	6h9HU9YuK8PkM93g9v56BOiRS8E2IjUI8fPgTMnwp10CwlTHZrS+XajPv/II5DRtuEN+3r5D68T
	1/raPsZUs44x4xbK5ZMVsx38DUL2jd+x2loanCR9EYiWpMGMZKpyd3txRA112N6IAGdfWUyZAZk
	TG4pkEMrjJriQbOGt1b4L9iemJ4yZcEcy6pxWZW2ej+wwJkiRtY6Y9U3HtdqC/Je7d9n1YS6K1G
	IvicY/8h68DMZgQcok6jIwAYB
X-Received: by 2002:a05:6512:2312:b0:5ba:3b01:36ac with SMTP id 2adb3069b0e04-5c170a09b09mr23774e87.56.1794505027795;
        Thu, 12 Nov 2026 09:37:07 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c157ba5363sm1914837e87.27.2026.11.12.09.37.07
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:37:07 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5c148d4dbfbso81762e87.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:37:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFPwB78fS1Uiom5qunbaxs6IWiyougcK5iGzxEa1kswh2wTAzW/+roY7KThwph40zEYbeQGe5xzGw==@kvack.org
X-Received: by 2002:a17:907:3ea7:b0:c4c:e344:ece7 with SMTP id
 a640c23a62f3a-c5066afe5dbmr615605366b.10.1794504534261; Thu, 12 Nov 2026
 09:28:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
 <avW3v-oLxcHXXNQD@pedro-suse.tail5790ac.ts.net> <4ae22b7a-c160-4003-a029-8a20381d196f@kernel.org>
 <avXFlI_5fhUvFyct@pedro-suse.tail5790ac.ts.net> <42373222-8e37-4658-bebd-dd27230a1dfa@kernel.org>
In-Reply-To: <42373222-8e37-4658-bebd-dd27230a1dfa@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Nov 2026 09:28:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh995y1B461rPAcgLagg26vsyXPoe=7JKgHowB+uHJJXA@mail.gmail.com>
X-Gm-Features: AclHuK90rViBZMbITCUjh4KTAKhE7_4EYJcdTbdgYzXWPc1JsLWFSAsYMdn-r7I
Message-ID: <CAHk-=wh995y1B461rPAcgLagg26vsyXPoe=7JKgHowB+uHJJXA@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
	Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-arch@vger.kernel.org, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2CA01C0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: bkeuhuoxa7gwhrftdpdbennanb4ka93t
X-Rspam-User: 
X-HE-Tag: 1794505029-924680
X-HE-Meta: U2FsdGVkX193gsxJfUxpZwTXrgZFYUQpfnBzTnJgl21JGf+Qp74/7KUK/D+jkZi8JQ1/1uVDvRMndu3+SOstiHWjbCfdwVqPeqoa2p01lX6/583gHmY7pp1OcasDMxxRIwxX33w9a78G02gfZax48h+Zw8HVi+jQ+DuG87MNdfhFnJ+BPFU8klntV30Qq6G6oHfufybzmusjYiPId14rcXovleucuVVjjZuv0k5xSDr1f7TgPJN8lGhXQRqRJvk2WXeGKoRDg3mHjEa8DfX+oGQD1v9Gms+NNWWrcYiJRaHFTUqdJd2TqKjiAZ1Wum9sdi34qzyQlAHK/UMLq556fpczR1f0t5IU7es3O3ZswOeRlD23Lz3ON4aziWSzz/hnwGa+kv/lc0YKRJsNyWTMvFe36h8rJ/igXZTABV10yx9ytl+gMqRl0eZGSHmTVB4FGmYn9ws/o/Holdmwjz3fE8GiJHmM/JqzAO7rZGsmPLC0/ExS7BNU+XcqxhW1SR6kdCvxgetzxp0/X7XTsWbQ25saRrJ/O5PreVkR5EIvB20SCo5lUHyhmfnB4ve48MMRVUbD7ApTvE3btaVKYF/UNg/A3WPUGtbuvh+lSQ32WNGQJV63Vx7yFzTKu9mJjw7zUW2xBQMiPSs9v6wtvr1HeOfZpGi6XgJkd9ODvahsIZDltiw4TOASD2BGIUFyFevbARMXZVA1OvwXeOiBcPaCMimAKYwQkvTcXNKUJ/R8Rixp96w2AQdR9H1BftdVFwZ1vTLkDhcdxJbmXb5deynRMyeUA+sEaYPbNUq1RAyt3r79/G1ZsbogEm3/2vBWG++CkIPJQ8VMZ143dyzVtFa9wBj1p4DxdIwQhc26Hf6I4CEIHW13j4rvPSrL2artGEK2Nla6XB/TsBCnyhuyaTHaUovqDw7RkTOOu4Ncmu2VWzjqbN88AOoOKQHq5X9MqvEM77ru9M/VSUqOWK78GXY
 51XZwCmF
 Haj1U7AN7Nf4bmI3cFqmaRPmHVQ92yl2IL9K2rDFItlc+bTOT71sibU4vc9rcMyT3jp2bwfsqXcd+90N92N4/godRHHfsX89xgykGnGRIWxgb0cfaI/KSQdl4YJ2BrcgifYmwo1E6dcbclkh1Du30kIGaAY62qU5tyaMzzhpUmhupXQ5Kv47WTLlKdkRpQ+guMkZX1J+fO5o2Rd+I31rNcmXYaw2/zUD1Q5KZBWzfabdU7kc8gZzCpqoERJ5m4n8QZTWWJTr1X1Nh76J6iYqO9cDm8fwc72/VvIEY8geBsdlSOmbUeXFW0npJfFQZM9MXx0jY+/f3/iosFIeRT6H6K58CxgzZrp8jvk6XLwb7bbKf4iEmryMIn6BVjOlgvagaGbuVzLabEZNTcRbzMVMCgA7mppQnfp17iGXrZWB7/L1fmYnJBLAP0v6hFu3DXI1CW1Ak2N3TG77P4/cTqpBEJYoveJymdXg14xqNIL9FsvKjb3k09c1TrcVxpGkh1xU/ogrzAf+wo7iJk0drEoS5kFHWMm9vDCE/aizVQFpuy7TwZWa95q8XHo/9TErLlwKbVRhuoESM5oUA44b/pN0ZGgj784HLaCFaNlEM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 at 06:31, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> On 11/12/26 15:00, Pedro Falcato wrote:
> >
> > ETOOMANYREFS I think is good, also EBUSY, EMLINK (though this would be weird)
> > or even a generic -EIO.
>
> So I used EFAULT because that's also what we currently return when
> generic_pipe_buf_get() fails through pipe_buf_get() in splice_pipe_to_pipe() and
> link_pipe().

Yes. It's not a very intuitive error code, I admit, but:

 (a) it *is* the error code we already use

 (b) it is a fairly unique error code that isn't normal (ie EINVAL etc
that can happen for multiple reasons)

 (c) this is  something that nobody should EVER EVER test for anyway

IOW, the actual error code doesn't matter. Nobody sane will ever care.
Some of them may be entirely unreachable due to resource allocation
issues. And we already use EFAULT for random historical reasons.

                Linus

