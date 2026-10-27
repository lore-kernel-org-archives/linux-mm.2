Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7437606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fYcJ4KMW
Received: by kanga.kvack.org (Postfix)
	id 7B73B6B08E0; Tue, 27 Oct 2026 16:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769986B08E1; Tue, 27 Oct 2026 16:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657D66B08E2; Tue, 27 Oct 2026 16:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3706D6B08E0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:51:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B96CA0AC1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:51:34 +0000 (UTC)
X-FDA: 85369602108.16.453A04C
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id C130C40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:51:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fYcJ4KMW;
	spf=pass (imf07.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793134292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wm+ZgGyt/5jKdn64UMl9fdg17TUAOdprcX045FIa67g=;
	b=TYfmZh9DzS5Jzqy0mH/YkTW2uIdqsaEFFpR4Htzgjl8o1uB0aUeY82C6SL+ubT4qoXWxrc
	3ZYHm+T9OcvFs8P/fQfnhyM/DNHrzZo+SoCEmDc5p7tBE5XkKEagc+zEdw5HOsjLv9p9vw
	PqM7ZnT2pI3W2NaYal/0coXxoBg2LP8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793134292;
	b=dU3RrDSUc1Or8xfCElw0OGhhnA/SoBASRIGO3feNAem0dYA7JKlUvjBHE4qb5f60GK7orl
	/dgChuFRxWs3NTR5sNQSb4jWeiacBrMAhQN1A7CNLBR/tu96DsoQ8ACDKWAIlxHQmH5/FA
	Y0Siw39QNCWRRM6lGq/SwwU3Jpj/COo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fYcJ4KMW;
	spf=pass (imf07.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-156cbe59524so265073c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:51:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793134291; cv=none;
        d=google.com; s=arc-20260327;
        b=aNYwKjNqu4K3rVV92Va7PUFMwkkmIctJFcVCxN32JcQKmVZKbwGREZayh2abmRP/Y8
         kaKojZcun/KvF82ww5zWWUZbfDRqw61lyN+m+ClOFQ/cMmOYTiw1rjPKMkJYf3UquK5E
         Dh+MyOIuWOD0EjACl3bGmR+72Kz99zdy6cjMVN95RM0JF5UekUfyIBk80+yL6cYX+Q8a
         eb/8YtRbZVRE/1/Zs5C31oJBloDVS3hltKD7+2+1/4HHlsUAYPUUQX7ZllS9gxIWXclG
         zSEzXqKcKab+JkuQDfcySzl+8YNvvkku0vuxLGVWjUY3idC0Cu4umcC80wLpFqT2oPDM
         V0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wm+ZgGyt/5jKdn64UMl9fdg17TUAOdprcX045FIa67g=;
        fh=2TSRbIYuQ1Lhz/nSQM8m78ve/MJyzCCa7Ye5M0I+Hqg=;
        b=CsY2+3YGvJ1XIGiG+KFp12U1sgHlhMp7StzubRlwymMtlTS6SZO/0IpGEkVlxjZAJ6
         aDLErmzz6RK7RYCrvbAGTW2pVU7ph7+YUx4eLeC3gighsTB1/yvCVlr97afJUfvhpNXP
         UI+Af/iFW9VY2ekz4P8dV0zsA/Lc4VTk6HEsSdkAAgPyK7KXtUBooAPb4OZ+rNgI54UL
         R723/nsZYO3/X10l7FT08JNmclUiGztIPzSy/gPjWan0hQmtDaW04qvbOp+LMQqD61h0
         onqhSRrAqKllu4jfw5ipYJioDwW9nObeq6vDbsdFYL3SFEEXaQiTM7e9bTRHV6amB4yj
         WeFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793134291; x=1793739091; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wm+ZgGyt/5jKdn64UMl9fdg17TUAOdprcX045FIa67g=;
        b=fYcJ4KMWfHl1daOblrEudaLnYUn7UqxBClEpLrhAXKBbIL2nJJs/NGZq59tmVbzPFz
         HG7M6YheHIYjPSJJq2JpDzB4fqjfyUi89Ol9/1b30/bLdEiyEYibgmMPtNJCjDl2D4j1
         zfBQGHffdMkhUqhKWZ0/NBA1e6ddBP3DQi3Uicfun5n+GoWJijdKloAff5Nc4UXWTG9q
         bjPEmK9yOR0N4QBGwVaRYZpUEMQV69C5+CVpiUp9Rz91Aiy6jMdwr1id/QC5yX0R/YEd
         DJ6mAWeTccR/NFAPvkC9y6H35ozc8n1tLLDBdR7+p6C/D3GNg5iHLfpuoKIEud46wmdB
         SU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793134291; x=1793739091;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wm+ZgGyt/5jKdn64UMl9fdg17TUAOdprcX045FIa67g=;
        b=ny2DPybtJobWANrEw9JehbnLgxaHWbhFGR3zqylQAPvTjqS4YRsg2LVGhkeR5J638M
         ksvDloOIEO15k4SaS9vkiJBiwzuRRlz/xQdbWZJyTWphXLblyjdIfbKL84FKga3QsAiQ
         +9zlREhCcnigpCe0bGRk/jPVYLPwng/mJPsC+KpdEWtU7JPpfV5XhTEA/zRzrQp1q7/9
         ph1NJdAC8ofGrl/iXH6UpupOsebdD9tjfwpv3HlbbO9iVF9dqwLZdFLTVS58wColJRiD
         KN2NHZI7T7Hkjf08ESeKdu56exPruAn0p+1BhiWWvd8hM6R3lLzvQC/8nYXsNFZkxA4E
         DbwA==
X-Gm-Message-State: AFq9FYJi5Uxp3mfL0ZVzVbNQMkIryOGLhw5aGLKCaXlDr/EEwBDkVHQ7
	DlYVX8CT4zqfJdfyNINjuGB/9yCTCa4qsleQZeVQSb+fMccYWFOs8TaKwqRiCpSoi9Vo5FbQ+nk
	ZdemiFTUq1+ziDwu0RQ+13TKCRN+bwfU=
X-Gm-Gg: AYBFou08qk9515KE0jUyDmoIcfHmYkn/ldQ6l+NPvtrVcbhZEMOO4VAOuZ+XWquQ07w
	UpMDNXXXmYBZpHd3CisF5EgyPpkgYEU3s4CZg5mmI8o0hEGIw1n94Jx7uZ9kLnywrWnlrfHyKjo
	/OqYJpWfg7vFUA2Edb2LmuHnWNSfe5sc6bx1kkGuuEtT0b8ii5gI4vTD4rngJflBgkPN6KtQADw
	Zk2olx3pNBBYeUlVKStxveUDshsDsTpwmeeUlaHwGzi0CYsDVachO+SLx8fl4EMs9dIMIHl74xO
	mig5P+4rfywKOa8L+xxhrS9eDiJAuWT/9ZGt4xc3TTGxq25zPDaV9lY8nl0ahN2xGd3fOSgsgZm
	mnL1lDeUbFgiIOl15vEVxlQjro2CqzJXYpF9cTET3Pxv9/E2xz8lv76p8S1Oj3yUwhgCH
X-Received: by 2002:a05:7022:7f0e:b0:147:a685:9125 with SMTP id
 a92af1059eb24-1a6c8105315mr436328c88.2.1793134291281; Tue, 27 Oct 2026
 13:51:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
 <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
In-Reply-To: <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
From: Saleh Mammadof <salehmammadof@gmail.com>
Date: Wed, 28 Oct 2026 00:51:19 +0400
X-Gm-Features: AclHuK8hGtJaJPTcfCesVb61NvbIvOen2Sly9Wxle1O3ush_tttklXAdXvqervs
Message-ID: <CAKu0nJWyt8OGYkYBdnUnWo3rT-FwKEwoTmsCe71vC4cfUcbE0Q@mail.gmail.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from invalidate_inode_pages2_range?
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Content-Type: multipart/alternative; boundary="000000000000776d5c065ed89cf8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C130C40003
X-Stat-Signature: 31ohemu1bd85q51giaf9zna36gqicsgw
X-Rspam-User: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793134292-590664
X-HE-Meta: U2FsdGVkX1+AH2Lqvkl+OQUpFy3qsOEZoBHK3uEbWLPBNBkv3yyEBISjKIqmRCTdYx9N44y4qQmlgpW8YYAsMPKwUTXGOtQA3+b+MdvE/WIwVN5bwzTOh9rkuJwbcvMCLNwMwQJHIAze/igYK6HYd+V+cCfdcBgj/2cKTCrH6hKuqfJFhkiwIe/isrm8Gh6CEHerVbUmpv/Lx3DnmoH1UqI9M0Tl77FmY8efgUmuHk7oDDatPHg7Hf5NcvR5WnVcBWgzc+NivbKtwIehlYGwjzpGypxsLLxVyb/PGqUJ2rgNyK+zkgOegnZEItc9PSW2TbXg4mmxV84gfl2iIyELZ+GuYdEDmt7EFetIX6C3ML0e8ROOA/hJQwHDex+4TJzmIZBVCF6vROriPleYBMjNz0ctuskKymCQCKb2QTYZmz/6VptWgCWvonUTBHeelUpl319+Apfy184zyDp96AFpGD806sWkN8d4TgnK3LFhWhrSSeq7VRddOgHiBzB4vqh3nlivSXFq5GBKq3pkyGTA6bBIbLYOSz8pn5rCWJvuaJVZA5l/RC1x65eADV4zhavUo+pI730Ox4M6KBbc0FTAq2KY0OzEBkLI01qnJneFLGIHZeq2UYUv16dZzYg66a3Fwh3RJtXhEnw8+dJMJURMd6PIvB3RaPQ5bwvd9XesraT+6iMcN/JToD652BrG2KUXop6gEmLylUwdnwNqgXvV9ZKggyDwLV6axPfWtWIw27iW72lJtNzw3DluXE84JWrIKUuZNzUGXtewaHo4yNxvpBOqQBEz5zssansdLuQ/1M0zsnvwx/qT0IVZbruUYma6Z0CNZa24ikMP6dRy6kk1y1xf2KRLnd0ow4A8H0l50hmJ4IoUtmKHqR7UkBsFzc6XH7eOc4kHrRUjKzs8f/2tyNo0LYUVvC/TmejDBa1zwf2aWdK6ZB82HaFUJuvdRtcxiwJqK8D957pYGuaUhm6
 xKTf9HzO
 MrpNyFZQuz4Sy2SjT4u2k6FoU86JmPnv3uPH12rZSG+I/7CucleXPf2FOSfcuDG3i/6AeQv4WdZFZ6m46qwp7tZZNS4b/s86qFp4N/xGtlQEz29dsEUoSpgiQUDcUqvA9+Dp4XhzYiaBWuKnTtJ5AADHd+GhL1WoPdmhzFvCAd135cF1NKiiyk51XO7bIcWg48neB0oc3m5sh+KVGfEiWgcGUBWJQheUo2/gUrEtVAJfkXP2TMg67sCgkKmpOgldUj/t44NaAGVDcOFpo5M9aVPQKjqqOSED9zdnxe0z41f9REVIzczCaG2XiS511bnA9XprR2R42x8jg8l/ZFmtvvRWIwSpDo37rlTjApjnY3OErQZ+DZ2L7GGG9BcN0B4lOFkqGj7fEUM0WBhis7ucbqUL9TTLCYdI14EyfpahapNY0p+eYpDyMkZ6gKmzA2a1ouuJRWQ9CnC5gUElrPTnr67uyb+eQCU+sDhuSuF8a7EeAeI81GJz7vdnh8zGz02LmgIm+z/Q7mdbX6p1G/VmtYkm8oe4apUgfvJXk7JNsFz4ayVDcB6N1dFa7i7CctUj8+pNf3SAwRblJIDX8eLq4BEyy8DKHEax9dWWYtipvrmGskhpbH6tKK1B+47H7/+/VjEvnp5k9Hk1ls00AOJBI+08hNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000776d5c065ed89cf8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jan, makes sense. I'll wait to hear what the btrfs folks think the
expected behavior should be.

On Mon, Oct 26, 2026 at 5:34=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:

> Hi!
>
> On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
> > Been going through mm/filemap.c lately and something caught my eye in
> > filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
> > the wbc variant) and then invalidate_inode_pages2_range(), but doesn't
> > seem to check either return value directly - just falls through to
> > filemap_check_errors() at the end.
> >
> > The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
> > folio won't evict (release_folio failing, launder_folio erroring out,
> > folio going dirty again mid-invalidation, etc), and
> filemap_check_errors()
> > only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
> > disappears?
>
> Yes. Whether it matters or not depends on the caller I guess so you shoul=
d
> discuss with the users of filemap_invalidate_inode() what they'd like the
> function to do. Adding btrfs people into the loop.
>
>                                                                 Honza
>
> > If I'm reading this right it could matter for callers that actually
> > branch on the return value - btrfs reflink bails out on a negative
> > return when clearing the destination cache, cifs sets
> > CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they
> > get back 0 when a folio was actually left behind, they'd think the
> > invalidation fully succeeded.
> >
> > Could be I'm missing some other path that catches this, genuinely not
> > sure. Haven't tried to reproduce it, just going off reading the code.
> > Let me know if I'm off base here.
> >
> > Saleh
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>

--000000000000776d5c065ed89cf8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Jan, makes sense. I&#39;ll wait to hear what the bt=
rfs folks think the expected behavior should be.</div><br><div class=3D"gma=
il_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mo=
n, Oct 26, 2026 at 5:34=E2=80=AFPM Jan Kara &lt;<a href=3D"mailto:jack@suse=
.cz">jack@suse.cz</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);p=
adding-left:1ex">Hi!<br>
<br>
On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:<br>
&gt; Been going through mm/filemap.c lately and something caught my eye in<=
br>
&gt; filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or<br=
>
&gt; the wbc variant) and then invalidate_inode_pages2_range(), but doesn&#=
39;t<br>
&gt; seem to check either return value directly - just falls through to<br>
&gt; filemap_check_errors() at the end.<br>
&gt; <br>
&gt; The thing is, invalidate_inode_pages2_range() can return -EBUSY if a<b=
r>
&gt; folio won&#39;t evict (release_folio failing, launder_folio erroring o=
ut,<br>
&gt; folio going dirty again mid-invalidation, etc), and filemap_check_erro=
rs()<br>
&gt; only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...<=
br>
&gt; disappears?<br>
<br>
Yes. Whether it matters or not depends on the caller I guess so you should<=
br>
discuss with the users of filemap_invalidate_inode() what they&#39;d like t=
he<br>
function to do. Adding btrfs people into the loop.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza<br>
<br>
&gt; If I&#39;m reading this right it could matter for callers that actuall=
y<br>
&gt; branch on the return value - btrfs reflink bails out on a negative<br>
&gt; return when clearing the destination cache, cifs sets<br>
&gt; CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they=
<br>
&gt; get back 0 when a folio was actually left behind, they&#39;d think the=
<br>
&gt; invalidation fully succeeded.<br>
&gt; <br>
&gt; Could be I&#39;m missing some other path that catches this, genuinely =
not<br>
&gt; sure. Haven&#39;t tried to reproduce it, just going off reading the co=
de.<br>
&gt; Let me know if I&#39;m off base here.<br>
&gt; <br>
&gt; Saleh<br>
-- <br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.com" target=3D"_blank">jack@suse.c=
om</a>&gt;<br>
SUSE Labs, CR<br>
</blockquote></div>

--000000000000776d5c065ed89cf8--

