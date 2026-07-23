Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E2CC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CCB6B0088; Thu, 23 Jul 2026 13:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26C56B008C; Thu, 23 Jul 2026 13:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1BF6B0095; Thu, 23 Jul 2026 13:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 583466B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:23:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEDEBA0052
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:23:43 +0000 (UTC)
X-FDA: 85020713526.05.3B73602
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id CDE354000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:23:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rdFwL1Hh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784827421;
	b=1MTucPpegj1zXt36Lm++pw5bsAHjqVzmJ8ZuiPHHcG/b03bAnWKV3bt//XaHUgAkLhgYs8
	o5qZohb5ygmG8SfLde0/zMogW0xKjU9r4rLOlhl3m46PR1xXRJxnNs4+SxlBlOgJWw2f15
	y9RFbYU147jXTwrFOvxbOOJWsfMVJuI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rdFwL1Hh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784827421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
	b=OEuW791AMoo4BWl4Cfw8bBVKqQRsGOItECX/BpfBN2rkZ1SewU/kV4LYE3DjgYaoeDBeuV
	wHVav1h4+5wOmqOe3tIqwd2WZ1A+X7Ajr/uyt++7dP5WZNB6ESPzJyLAL0LPexlNtfGY5L
	16XpeyHohariJjSa0mNlfu/sO4jPtpA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c10e86e52so10091cf.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784827421; cv=none;
        d=google.com; s=arc-20260327;
        b=e//HqsCl29MIYxKev0tL8ARZedYOsWDG+AZ4t5VNMaPG0n14qlW/+paxDrW3PtPXLz
         O0Z2h8mD/hYoZc2kFRav//ykxJU1dps63q5ssv4jOntoshedM/Km/0RLNXhMKqQDDnGq
         aagHLw+EFRurQtZuXsQUz6eAGTZw01pOHVHTTVIi3ICnK1e0sEctuX3JJnJtmXnh184o
         FspsZwLlNPuXftbPmnA/CI3XeT9aWA5VrP0PkTCExao05qRYphw2sumImtwpt1zcz+NT
         5GrvyfxTysdvXugwjK3e6EGpP8VjWMM2j4l44Xj9PxMf/MiUqwLe+3PP+/m8lwt9bqWV
         //+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        fh=ji7EqoOOQSk5GDx9qh/gq6N8saSxlcgxqdVthTGrko4=;
        b=Y4nNlJ/y1/IN34esIs/vZUgGLGjom8Ug8I4N0Qr5ReSvt8HIFCBYtZmG7LIlEyLxib
         rRMXq3WbRQLRW43CgqUiFastdoY0RPg6RAIqyvVrC+Ih1Jw/9xwMTqK7ta0lB3ecAUbj
         UhGaGvvzr0Ft0DCdY92igWtgols1nKHIpSLMAqN11JiLevVbUFj4c5oC1KqY315px11Q
         2h1iEonINFGhJspmsRUs8th037rl+H6nTqsdGrUfnGrQ/B2Tt9QTXXEJb8q+c0OmF+u7
         Vqj+cFPzFtgNmt2izKIZkVLsqrlJIavv2bU+JS4lmx4POJS1IyPXD6DI5VbgZ8udUf6G
         V/7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784827421; x=1785432221; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        b=rdFwL1Hh43GoUpftn+Uo+AWlyKHQtzQNXjTsv+Hi683h3n2vnVxiPIjaye/ZbYxu7I
         6y9+Kjilvf8ibbbNebivO1r2NY7kw/YNVMSvF8Bw57tHeqgKVuNa9MN9qlZjt6d/1jwS
         HhLL6Ab8kKErejK0eHzFnxSAEkLo4g1fP9t1Z1Y+IgjA7l8cu3Vveoi4lLL/rq+HdVH4
         78BVWgfY8sRu6+pMnNDk00hEHikmYP/rvks/V2rhajrrT+51qps+E8ORsY0d+NIm+WNp
         o84UQK0tYJyoCzuy88TYoKIRbx0OUb/8CwEo4cSDMuu7r6uLqVndMb8s4pcadmzqDsUK
         EcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784827421; x=1785432221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OvWHc0ZW5fLjVgw908l7SM5IZjGliZrnWdGtx8j1ar4=;
        b=IqMvA6f7GdIbvEwr8Cu0lZPKAkr+4YN3xYVqm5T0OMu6fSOBfL4o8AaNC8XXywvY9M
         QkpqI8hKNpgPy4C9uz/kD3QFlzhRgI4JtV+fV2V6ufwyLOYP1n6c90C010Y7DzjgqOLU
         XMaIMw7L++b+qQXlrv1uCxySbJ/brinWm4ztO30FLztdR0cUdo13Z35wR3i7T+F2miW4
         pvfCCh9tFL8fFQ+pO06h8nH76HDL6F1PkasJ4AxBAG7Xwzh2sCjHIpskuE8cbU5s/ZTi
         SgsMG2K24D+00EKKmbTZB6p8/r2mQQAMNSYKOPcuy3lgUy6a15Q632/RdpJ34R2JqdPW
         Xy+w==
X-Forwarded-Encrypted: i=1; AHgh+Rpzgbd6M8j3+Aeq00nEmD+BIFUO9Vq2ko2DgV7PAJh9FKuQbJSsNVMREr8KXdxtLUrnJoYM5sdzVg==@kvack.org
X-Gm-Message-State: AOJu0YzIoh7Nt2BdZgvl8XDmNoGA2PLXZzwTUVbUbKHjSG9mELh6AD/O
	PlkAVfP8y5URfKSYgqAoYMJuIAyWHEElhD0ATeinEGkT1T6KR4jV8hKsqtgpxnpVcL68Zr6sPMS
	B6M7/Sl5NqnAZ3CwITuNFkkwIiJpbfD2QKCDgqWg8R4WctPUpvz30FZM4NWw=
X-Gm-Gg: AR+sD12O2ISMG/1HsZGtXtBf7hGvavL2H7AcDu0J2aKCydwdmwjrLLJIun0+UYejgr7
	PuowQDdDEX0ZUm1EmA4A6ulF9PFReY0iGXjv2SCYri8aZOaGAYBqKxcSu0QtBhMLN+sFOQ9+6CS
	0lEoku2669B5YQGXo3m+VRiGeTWNdV0WFdNMMwB4iFytlfhXXm8SqNJ2cIep75SqFE8GFdfC0Vm
	H00LDFzyUcuJMi369bzuOGL/TI0QJJrzghfRhVhrO7AOMPy/zf+nWi0l+LAcskAFl8EwAhA2GIY
	dkMKoHGEYDst7c83hD0CpYHQ
X-Received: by 2002:a05:622a:124b:b0:51c:289:6979 with SMTP id
 d75a77b69052e-5284ac9d4e4mr112451cf.21.1784827420090; Thu, 23 Jul 2026
 10:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org> <amH7ndu2TAd4ixKU@fedora>
In-Reply-To: <amH7ndu2TAd4ixKU@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 23 Jul 2026 17:23:28 +0000
X-Gm-Features: AUfX_mw1njn7tPFKe87j3lzybQQ47T04IbnV6qBbIg0pwmajyEd7e5gU_4Gj458
Message-ID: <CAJuCfpG+pzf5_D_zF1NPB0n_dukveA5YJy9sG9RExj76ZZSJkA@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] mm/slab: abstract slabobj_ext.objcg access
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1k93digbqwoa33dyzqswesp13dhrmhyt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CDE354000A
X-Rspam-User: 
X-HE-Tag: 1784827421-730090
X-HE-Meta: U2FsdGVkX1+7UML2vW9to6yrAufnUJE2Kp75N2wCMYlhh5DGzA/H1dzvW06YAKjRJIiA6cscrtwfTcshTNYPNL4y6dg/1WSOJPwPoaMZ+NhfF21t7In9gIjIZPZWR80Hg814QhxuFmnoy2xVE1EXkbuf/FVzJeehhI2ygPV/cwOdj76PvQoIgxhawZKa6m4JNoa3s3bTrQCqoda35ZH+jdsc9w2xRQPnveHlsGpB8ggPl6GEEwDCevy4fplFuyrUYaB56QdzDltUZGaFVi0F/lsEv3rYfDjIYjtlasHrblnXNee1ChwbhhZbRvcg6SAWXFH4ZWgd7e3HN3Xo00z1lANd8lrpiRZHBFhlBH4+QFUq6slgBjLSN60Up/kFk8NByPuEMG+xYAXLTtx/yBv8ti8fdE/a/Lmh4qW1EDMYypnyK2HnLGcsP4A3QsS7NE9vMeXDwVXahBnSLzDU0X3JZfuyCCHx4tOwQJ2VxdrXLEgc8OwAL/38ATrrpH2+fyAUDbqMJLl/FbZrBfPD17gr6jtI1tbrV03sLtj0DrM2P7er/RtLklTVsffNNkPjOiyt8FdCwQ+2TeZQaF40caqtbwO2j37EyGy/FpQiSWs9BX4SST9eX/G4SLghr7SukmrwPIthGu/r70+ELDIkZUTO+leG8FISpK7tt6J3s85EV9H67pRAKBenlXHn+BbPd/1SsSyFU+cJtka404w0v16PrVsU/RkGhJakqy2wwAOldo0/m5ASVhxfDmpKDzMum/cZN+GQEjE+m1H/qtSuKfsZ0v79njrMaWJHn1JmZVdTfhx/M7bCs/C6m0qotLiJmIxU6oFBi1fEn/YHkimHuFjINS1n/U9Xr7+QSXVMzNTSgZo/hMGdCER7XrJsagguWKDdI3xhlrzHh9iVT3O4J/2Qbs+BGTAJFuSkhnwqH0+D6VD8GI/Pg8rl11/TYS8gB1jlICGosHPfFzONDHp0aML
 9GPuCnf9
 jUjt4ryo401O+9Naan/3vlDxnxnFNqmU6nPkC0vib3U9v2dNQRFsEdciDVOVYaxLz5CXYIuy5E4zaqIsk5i/YcvcIDhviqgm9TJx/cpch8CvrEve1L3x3u+eA7gZAYXRl1kN/DXJRdSN1zw2OGQ7fIuevSbay0AFtObhPkMxhL/jelxy4AvPIcDQzvZNytxDOoBrlQbJTFzXIaZOqtkbZ+Zqo120Tcg9dH5mzmRUZxjv0FaAhVe0iVXtEigzPTjVlSatSNIzcm/NQeYlsPUqCRgbGz6sbrY+NQjhmmED626WzX3MC4JpxsBldIz+1nkxV0npmEe2pHcIsCupn/AVBuVbQgMZkbpU1NP/TUsCM/WKAOxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:32=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Mon, Jul 20, 2026 at 04:16:20PM +0200, Vlastimil Babka (SUSE) wrote:
> > In preparation for changes to the structure, abstract getting and
> > setting the objcg field with slab_obj_ext_objcg() and
> > slab_obj_ext_set_objcg().
> > Rename the field to _objcg to make an unexpected direct access a compil=
e
> > error.
> >
> > No functional change intended.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

