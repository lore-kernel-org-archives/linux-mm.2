Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99706CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B495F8E0008; Tue,  9 Sep 2025 17:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFACC8E0003; Tue,  9 Sep 2025 17:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C17B8E0008; Tue,  9 Sep 2025 17:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 820EB8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:10:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3B7E85B16
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:10:23 +0000 (UTC)
X-FDA: 83870955126.19.A63B44B
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id A389E40007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:10:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=fgAvXLeD;
	spf=pass (imf01.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757452222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2cG/mK5wqDybUQGFQEkWBC5lBJfTdv6AvrW8OgR6q8=;
	b=lmwF7v9gxIeVHXDx4nBKS4ZMsFShwE5NW5ZOenCGRcy+faTHWy5tiyNy2dKdYfKnvD0lNt
	aQglVjIJxGUXo4ZACUKEluKIJnFnJ4j4HMqUCfK3X0QHRD4KDtVpDZ0+6ZwK4Nh7iJHvJd
	WAYXyTZjCfQlsijekvvQEI8t7F+V9nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757452222; a=rsa-sha256;
	cv=none;
	b=2tzF7u1zVYcBm3opfNOiQimJybinxGxDOB35W5wNCMab2F/jUiwn2UvHkKNH5OsUCXCC93
	loWSjIh1PzLNUvDW4aM8uyM8we/is3fNpf02D3rLremIXYjcsTKOHVBATZK/JNP2XIrseo
	91EUTGhFd3IwMpe8xy7XWLKCAZYDWQY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=fgAvXLeD;
	spf=pass (imf01.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32da35469f7so1253381a91.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 14:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1757452220; x=1758057020; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2cG/mK5wqDybUQGFQEkWBC5lBJfTdv6AvrW8OgR6q8=;
        b=fgAvXLeDGrUeMkVi5r75yJB1J5TEp+iS2X53fpnwQeD6celpYRqxBsRm136h/ZAQic
         FbnYznuYiIQYHs2nvTQUs8SL+YtWpv4xGKVCzvSSxebAHxuYHZEVy+JRutehp4jrRSAt
         IBoS9/IOrDCCiPt1yZuUYyjTYTUl+B5DV+0WPdjRUCOG62YUis7RUE3IajJArWx+Hso1
         bNVl4hZJKTMC+9f0NmwjTMlWlqRIEF2dxSmLVUCJw1oLi7BNpvrCWOkneSkv8QKHUT5J
         w7hfBFECr2rlTH7WiyUX3t/RRi+qBXMAiR73XnSa5Q5otdMQ1vA8/uvA1gBRYtlIQcV0
         3Jkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757452220; x=1758057020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2cG/mK5wqDybUQGFQEkWBC5lBJfTdv6AvrW8OgR6q8=;
        b=igi8kMmrse3NlkE2eyUqxhWsLx1v9whUnV7kR8ZJj+R5MIIYgDqVAiAujHxLx+Acj6
         DYOVCmuSYxsavrGRh3ec5RCSqvSOLjMPi7ZaWyv3uQJEduj7zzHNCK2D1btJQhfaCVBS
         B+UUVXEsorfzXRko3yjUZQslXBpMHC0RT8WbCfJ1Sx6Yfx1c/gWa0km4AW3QT8Qa/Rm1
         CpfevjeViwxtbUQ6CHTWQWtbkZvKlXkpcTQQRtzG4Kkczj9H++CoeUOpQB9Ofcpe2TEk
         VcmKi6B14qKIzznagzz2gyMB+eEIUPq0Wzq1qckBy80IANXK4GsOwlVi7FUWedWcw849
         ff3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfDMfcZA5MKT8IObyWhEqLAhIitnUt6W/Vb5IcQ45HPs4p1KyTZu/4iNq9Kvwx7/gBGuCObi5OuQ==@kvack.org
X-Gm-Message-State: AOJu0YzNa2VSRJiRWg514COoU+tbBY2cMVRHEDjQD13Ol4YNZsIg1eV3
	pfWi51oFY4Aj2YyJSNORn93hY7PVIh9WY57TQWwekfdBsG0clfqC0LTU+66NKBu1SeCfCysCnCO
	Ue6CY4sTK+UMZp/lp1jsl+hT8R2tLAQ+CH5yAwwJs
X-Gm-Gg: ASbGnctMyjqP1G1g1VyAToFhjmZowRXr+NnRofndI9IBFhTlWJeqFVwtEXTeQY6e08S
	jdTVCklNUCEkvZBsPrb+j7UBbCacBuW9e1J5/zGX9Nga3OzA4G/owtPXlW2tB2Fx9LZw6eE0VPC
	MZKoFyDzIHSldElv/ZxEcz6HhSViDNiD1ay8cz5K0Fb6iPJmC9OGyPo3LZwpS4R/xmHOX6aF6Qd
	w90JCo=
X-Google-Smtp-Source: AGHT+IFG7w3FOCnO7S8iIokZgAsSINZsrpiz3Ys96zLr6kCQRn865YPB71KK71zIy8iQMBZAebWvkkV/MJhLqntWdHY=
X-Received: by 2002:a17:90b:3c0f:b0:329:f408:1070 with SMTP id
 98e67ed59e1d1-32d43fcfd9emr20011740a91.33.1757452220060; Tue, 09 Sep 2025
 14:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250908013419.4186627-1-tweek@google.com> <CAEjxPJ5q0eriGjo1tdfN+pzBBN5OeyfMaYp_sNQcOg-rDaXVCA@mail.gmail.com>
In-Reply-To: <CAEjxPJ5q0eriGjo1tdfN+pzBBN5OeyfMaYp_sNQcOg-rDaXVCA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 9 Sep 2025 17:10:08 -0400
X-Gm-Features: Ac12FXwWb3SOwQ7VnHVntpJWLHK5Nv99C1sNZTrun4dRgTex4G1DZb8W4i4WZ_Q
Message-ID: <CAHC9VhR1pEFYzSFaqqWsU8C6vDaH_E8uZZ5g=KyK6TJvA7a8MQ@mail.gmail.com>
Subject: Re: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	James Morris <jmorris@namei.org>, Hugh Dickins <hughd@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 513fm1kb6ugapqm4nzkx4t31c5mqdtzh
X-Rspamd-Queue-Id: A389E40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757452221-576940
X-HE-Meta: U2FsdGVkX19b2SavEKd/OAeAkfTEuUJQt4SQyccKSE41E5ACKrtoVp3TAFlfG4KLtug0RvtfbnjDNiTLOYx3GLTdARDHIeaF6ETHrh5AaRetsr621IJSZKYoKZQFy6ok2ZGJTpUE4pzLVueITQKYQK6nN7oqPF/ElKBtMD3LYwlAMpvm68RqVqBWt1e7ut8UXLcbeYRvvnsHwbt46JuMR2MxIvKpmOKEnsRaqmGUbGxdDsKUBr5/54quyBeKL3bIpQJ30AECd/qQTkSSapCtgA3alCh7fMt5K2FWbtzHBXTtt1UF1ZCZAjDKhwbF6l4JJ0RC91qjkTOindR1Vtdo0V7XhN3MAYHS1O4FvGbJrUrgjHhGI+YNpL6XxY9FIbwb2mClaE3BY6iTDE4eSY6oVKJdTQRU/ORc6HLNkYthNZigiG51v5TEgzOeSdRHEwqA+iAlUkQQGtat6c+2sMT5qwUqIr2t7xyl6LjkpDge2ZOXeUlqKVm3iKEMKO6g/Z1lVBcaV7trNN0vk5Dny99rZM3CRMHbVkVM7345Cbb6jMLxOpBikYyXzzdIVo/kQppImmeqWgF9WfoUFRv2ar7Vy2Mbf0onJC9s1Y+jqIvVyVqx4iw2mMswSBYNiPZuZoGIShWfuNxkIPRUn7pQkh987hSxrhrJ+X09qtpOGGDFN5WOql2pECNz7KU80zr2+dTHL7C2WQleaq/dCy7t/Zi0QTEyTU+taxq7q++aoHJLCFEN1EZgDl2l04HEv8E+6exNcKdMAcSCNJ7VIRj7dxTWVptGnyfj5rVA3sDY0ay2f3mUhgjZTQPEnDHOo0Kr0fB2PxdqJrl5xzSNetWfHVGxDqUOCwGFaQHgahVRn3mLXLA7g7JQRs8GPfC/judwi/n2Arx4Bl99YRvCLbsrZSuHq+z5jKUi5SyCyCn3QszEvS4U9rkfCz3LhQAyl+Vn71Wrha0saiW8Sr5IAwQChMI
 X1G2x1Ch
 7vt88DB8hgRbrbvf8zAtgTEsUQTKpnMJcbhOmI/AmzSKrJD3XzH8o6MRspUo5TJ9r/WwWMxKZO0BOcL6LbyLRzN7Qyu6mwacdq+ZCJEgSHllz5+Cha8YXa15uB5OrSI8GgyxnN2r4RqRFt2E6F4zT85cq6sOzTDqzJbfM5xt3r57Q+EikVJrxA0p2o/3KRVDubEExg/RAtHmVbDKHRbYQbDyh7KS60QISxUlOmBQuUFsqGA7d/adzujQeOR6CXEQ5SUHcsIpgRlyltKkZivCIBuRywM0VgXd6K4YvBQZTtb47MygVUBurgG7IXRKlVnSd+JJr2Ws/rMTs8KwCAwUUlacf2/n/5JrGx1JwQCjEVKdRaHYIkAsCDfRg6SLHWSn/u2DwYH7DvDNfT9Ina0E1UUBhVtpIUNcL9Umz6g4qZ6P3q80sIvMW8Dv4KJQShGbavFvbz9F1vbh27QYyx40fdRV/aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 12:32=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Sun, Sep 7, 2025 at 9:34=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@goog=
le.com> wrote:
> >
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >
> > Guard these changes behind a new policy capability named "memfd_class".
> >
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > ---
> > Changes since v1:
> > - Move test of class earlier in selinux_bprm_creds_for_exec
> > - Remove duplicate call to security_transition_sid
> >
> > Changes since RFC:
> > - Remove enum argument, simply compare the anon inode name
> > - Introduce a policy capability for compatility
> > - Add validation of class in selinux_bprm_creds_for_exec
> >
> >  include/linux/memfd.h                      |  2 ++
> >  mm/memfd.c                                 | 14 ++++++++++--
> >  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
> >  security/selinux/include/classmap.h        |  2 ++
> >  security/selinux/include/policycap.h       |  1 +
> >  security/selinux/include/policycap_names.h |  1 +
> >  security/selinux/include/security.h        |  5 +++++
> >  7 files changed, 44 insertions(+), 7 deletions(-)
> >
>
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index c95a5874bf7d..6adf2f393ed9 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2315,6 +2316,9 @@ static int selinux_bprm_creds_for_exec(struct lin=
ux_binprm *bprm)
> >         new_tsec =3D selinux_cred(bprm->cred);
> >         isec =3D inode_security(inode);
> >
> > +       if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLA=
SS_MEMFD_FILE)
> > +               return -EPERM;
> > +
>
> Sorry, I should have mentioned this earlier, but usually we try to
> avoid triggering silent denials from SELinux since it provides no hint
> to the user as to what went wrong or how to resolve.

Ooof, yeah, I should have noticed that too.

> Arguably reaching this code would be suggestive of a kernel bug but I
> know that BUG_ON() is frowned upon these days.
> Maybe we should WARN_ON_ONCE() here or similar?

BUG_ON() is definitely a no-no, but WARN_ON_ONCE()/WARN_ON() is still
considered okay last I checked (no forced panic).  Of the two I think
WARN_ON() would be a better choice here.

> We also rarely return
> -EPERM from SELinux outside of capability checks since usually EPERM
> means a failed capability check
> (vs -EACCES). Defer to Paul on how/if he wants to handle this and
> whether it requires re-spinning this patch or just a follow-on one.

Another fair point.

Considering that we are at -rc5 right now, we only have a few more
days left in the current dev cycle, I'm going to merge this now (with
a subject line tweak and some unnecessary vertical whitespace
removed), and I'll put together a quick little patch to do the
WARN_ON()/EACCES conversion which you'll see on list shortly ...

--=20
paul-moore.com

