Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90F8D68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2799D6B00AF; Sun, 21 Dec 2025 04:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227466B00B1; Sun, 21 Dec 2025 04:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1091C6B00B2; Sun, 21 Dec 2025 04:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25576B00AF
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:35:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CEC7C0EB5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:35:47 +0000 (UTC)
X-FDA: 84242971134.12.94127E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42087A000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:35:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fPucl+5C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766309745; a=rsa-sha256;
	cv=none;
	b=xZr32INbRjrt2DYRMPm2CpejblctNP3M7peXdphdDoDjJSdQAgx91eDImJSsKwrNP/zvUu
	yWGASS/+z6nwbE9SE8eTwvcicVVnzv9e3BxwkeNqV8VESxKIcNGQkMh9wqDX/5IBbV0C7n
	a4uT/4CiDk2QEUQAkQo8gCAOkCf1Duk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fPucl+5C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766309745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0b0ttvVfnzqnnqxYqjwrgGto4u6m79oNU2NLdK5EaY=;
	b=zaFdaCnL6VKHobpw32nA9mNbey9V0J/GxoOHLFTovsdLMmEd4QqL0FjOHjy3mVH21NH8gH
	Pim0j1Vfel9hyq41t73hepkOGiFxtekaW4geUW25rmNydnSJjeNsergoJn3SaeKVASTQ4E
	npWUjReQHy5FJtR2JPX/pkbhUfbLpDo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766309744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K0b0ttvVfnzqnnqxYqjwrgGto4u6m79oNU2NLdK5EaY=;
	b=fPucl+5Cy/jvnooerrd6aDNp4oWqM6+1Swgm+1hJREIFT1XElhkpQqRYgoYi/E/soU6PXq
	yxcHnQvHYsL6UMLgX4XFDkX1S9/bq/qKufco2PAqXTaMnCW2IKK3W/g3WwxOo7RJmhvpyW
	5egpp4zsYNJ5uf7EX+ANkfIbAnn23F8=
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com
 [74.125.82.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-zKGtIlV1NbmMVl09Oo8VVA-1; Sun, 21 Dec 2025 04:35:42 -0500
X-MC-Unique: zKGtIlV1NbmMVl09Oo8VVA-1
X-Mimecast-MFC-AGG-ID: zKGtIlV1NbmMVl09Oo8VVA_1766309741
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2ac34c4b41fso3829531eec.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 01:35:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766309741; x=1766914541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K0b0ttvVfnzqnnqxYqjwrgGto4u6m79oNU2NLdK5EaY=;
        b=OebcWf9SuJ4DswHWWfl4NtZ/T5LN1DXSca6mMoAH4ZdID80AbjRScfiE4QqQXHutch
         CA9BkuLipbKMn3UvnjblM7fIEvHrE3ZIFYTZJR7SRrCNmKYDLIHTyif1lH5+C06vp1p1
         latbdU+b7QB1+KoRKGeYukGK9jzTF8TYaHW+kPuaZ5orJwM9nGWuej3QfUDupmS03uj2
         OwEuCsXOMtFrm5DVMe6/LmA4pfsuR1Czzy0dMlUyagewNUxFgBH55YilH3/XjIcjxfs4
         DaQRH6wYyt+tsl7hCMRCB97qjocVoSY1AQ6A0UKYvM0+bVMG77SLfD2vP5+MnsgQSbex
         lwvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXln1hxooYK3AWNnpNgyQJcguDmBqrRkYAtaM6vQaJ+8YGYqo+yWudn+rYMH5khmtuAgL7Tw11y8w==@kvack.org
X-Gm-Message-State: AOJu0Ywhcvy23i0f5TD2mCCaWhvb2PLYGxj5tmx0Pwrifb105xHiyI2N
	LHngJNek/LO0vqUZ8eCZCsCR9zlo8/KRu8uoIxWgHVuNMbVoIja9ceorFcum2IX9g0XrcqmW3fh
	F8nkmsXrYQev/38J91X0yA5w4FyJELT9IA1d0Au7DWAW0sVBILgjNgea0fM2xE5MVuczgvuCgE+
	KQvxx8uoqf2JSXK3bgTFwMBz94KxY=
X-Gm-Gg: AY/fxX4eAtza/4eIpMi/JyYhAn/C+uNOFkvFmsiPVg7ncqhHHGzjmSIl5DLuIqIz5Yq
	1WHgqtcFhfddKcp0u5ujMuLDgS/ofdgTZnmtMdp/PRcG66kz2+KQBpbXLWfjDzI//zh7mgBPD4C
	Qmszo+i50MWS741EPYQDRLSHtyc6OyXZ5HDT6SYttP+TZ+jKg1n+9kPDA9p0f227Z5/kw=
X-Received: by 2002:a05:7300:e2c4:b0:2a9:9125:ac0c with SMTP id 5a478bee46e88-2b04cb3be5emr12744658eec.9.1766309740984;
        Sun, 21 Dec 2025 01:35:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUw9TgWiHOkqocZLrZuRSZYEWQGLXVlBNWuV5SikvrxsD/8J+sWbXaeQCGZlrmMv1T0rJtd+XOi0Aj6jWZZgI=
X-Received: by 2002:a05:7300:e2c4:b0:2a9:9125:ac0c with SMTP id
 5a478bee46e88-2b04cb3be5emr12744636eec.9.1766309740573; Sun, 21 Dec 2025
 01:35:40 -0800 (PST)
MIME-Version: 1.0
References: <20251221085810.3163919-1-liwang@redhat.com> <20251221085810.3163919-3-liwang@redhat.com>
 <74414ade-63fb-47ff-adda-903949468b88@kernel.org>
In-Reply-To: <74414ade-63fb-47ff-adda-903949468b88@kernel.org>
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 17:35:28 +0800
X-Gm-Features: AQt7F2pI9TPRNFP6_5rrof-BE4Ld9AmH3MgEbxo8XJtb4yqP0gpcixLOLcYjTg0
Message-ID: <CAEemH2eH0a6vHhv80hDcTBxTUYHALrOKjtvWnajCwPk_zLpJ3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ubUr4QZoVM_5zWQ3TyZ5Bkx6CtZT59sq03NDVvN7I_U_1766309741
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42087A000B
X-Stat-Signature: 1ot5z1tfat5e8y937qrbyja8xtnsa9n1
X-Rspam-User: 
X-HE-Tag: 1766309745-108858
X-HE-Meta: U2FsdGVkX19FY1hqUdcnmy+xJNy5H1nMXnpf2ZcfOsUvu+MWebIvSl8qycJDzr5QEklA5MpzTQmei7w11wMBq8Xv1CdfVb1Z2bwnDBvWYYuLwyVbnHyX+ekTMtDCCihp4FQq/9gVGYJWlEjRTC98swGmZ87rlF3Oyt2mqhqx+DCTvRlsvizrTFowkb98/65DDyTBYvvtnRzC+BfomUma+p9GK6n0oKUz7N017D9HQzDKBGZ6es1+xvGJdZ2nIlPZYFVEDN8j+xNswraK/JaOVbv0vB7SbGlLLy6S54Lyt+0ToSE3qPlPjbZJrlbthZf4A0M02fqez0cnW1zbGrfQe/CM2W8R8IhG6M4vrtUwatNLew+ZjL2XqB3FEvMIlX5ULs17IfjmXY2qpUzg4X2H06FPFoiz7cp3GTyd8iLMBeXh9NbdMrqUlF8IO0DCEMsGe1nNq7qpIM/hDN/zbyKZ0QFXUPd0RDwtK1+rmiC/I+HGw+KuU/ztY81CIpSeUgWCmxS9kJp/CjzBEXpOhiMTwiqyPb6rmaPk9KkUKXqLozJckQVwlApM3vTwhyLUK7wBY4RczZHvnp+UIjXtOHm/7TK+ymUB8HucyhgPFoXV1aB3J3nYxPR99hhpM6kkoDN2tQI+yxL/g+D7avygWgabcwOsOXgRYKAunMEkbaHILk0eoHIDJS7KaPH9uHlu6s2WKO5Z+3mRPojlyHOUS3AgTF2HAeKQuHyVAtBR8p00TM7p5SBQzgj5M3o7CQZJUi5cHsA7gw92nyBYE4nDenNg6jfWruBQONcRHVgzWmi4cjgm58S5fTytD/SSNIzFWqfHS4s1o5lv4xgJeD9vhJQPkAMU8tkUgUCW7lFhvtFEhhtym9aHp5jMISoNCpIrIo01myseTKxiRrJXe0ksxEleXcu8gu+ERTJfNk+BX8lZCE4yujVUVDMU3C4O7ePSt3pzpNVV/NoSZERvOqXsmPM
 F4aS1Pvn
 F+MSpI0la0aSByWs1ZrQbcgdRMbzSRUMfYdGYdL0i5X6nimI+hEm72WSAizVwMY3ZsMO8bcbdD7jzZLEoN8XJ8c4iCjveNSHih7j+XHforb2uGrepqvM4qYE21T2cFC+KsximqgGBG1QAYHmAhyQYRhLsrzMW0anVYz16d7QEVuM+Wll3zQkR1X49JBRDa0V6jYUwFRA5xUgCBnQdtGXf9J1TIWhUXjnOWrd/jno3m/3anVJRFGGDFR0/U7l8uKICwh45maCuQwa4vpYg9YCqRscNFqYmlmtL3NsQwIGANcUP2vo3TAwGOwr2NnXJ3T2Fr2O4dTV0qYfHjHpYtBOJNIZpYLgt5kSCVAsw3RFX//zjldKWI7uhumePUyuPpfYhFclx0MarEmQ2buTCrMtc6aQ0pp6YvoKcog/OGnrubG39+fco+yS++FSUuP8YxNXnjWIX6v4NHD7G9iC8qS7fZQgRB0n42xyJBScD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Red Hat) <david@kernel.org> wrote:

> On 12/21/25 09:58, Li Wang wrote:
> > The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
> > unbounded and could hang forever if the expected cgroup file value neve=
r
> > appears (e.g. due to bugs, timing issues, or unexpected behavior).
>
> Did you actually hit that in practice? Just wondering.

Yes.

On an aarch64 64k setup with 512MB hugepages, the test failed earlier
(hugetlbfs got mounted with an effective size of 0 due to size=3D256M), so
write_to_hugetlbfs couldn=E2=80=99t allocate the expected pages. After that=
, the
script=E2=80=99s wait loops never observed the target value, so they spun f=
orever.

Detail see below logs.

>
> >
> > --- Error log ---
> >    # uname -r
> >    6.12.0-xxx.el10.aarch64+64k
> >
> >    # ls /sys/kernel/mm/hugepages/hugepages-*
> >    hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> >
> >    #./charge_reserved_hugetlb.sh -cgroup-v2
> >    # -----------------------------------------
> >    ...
> >    # nr hugepages =3D 10
> >    # writing cgroup limit: 5368709120
> >    # writing reseravation limit: 5368709120
> >    ...
> >    # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    # Waiting for hugetlb memory reservation to reach size 2684354560.
> >    # 0
> >    ...
> >
> > Introduce a small helper, wait_for_file_value(), and use it for:
> >    - waiting for reservation usage to drop to 0,
> >    - waiting for reservation usage to reach a given size,
> >    - waiting for fault usage to reach a given size.
> >
> > This makes the waits consistent and adds a hard timeout (120 tries with
> > 0.5s sleep) so the test fails instead of stalling indefinitely.
> >
> > Signed-off-by: Li Wang <liwang@redhat.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Waiman Long <longman@redhat.com>
> > ---
> >   .../selftests/mm/charge_reserved_hugetlb.sh   | 47 ++++++++++--------=
-
> >   1 file changed, 26 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/to=
ols/testing/selftests/mm/charge_reserved_hugetlb.sh
> > index e1fe16bcbbe8..249a5776c074 100755
> > --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> > +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> > @@ -100,7 +100,7 @@ function setup_cgroup() {
> >     echo writing cgroup limit: "$cgroup_limit"
> >     echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_lim=
it_file
> >
> > -  echo writing reseravation limit: "$reservation_limit"
> > +  echo writing reservation limit: "$reservation_limit"
> >     echo "$reservation_limit" > \
> >       $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
> >
> > @@ -112,41 +112,46 @@ function setup_cgroup() {
> >     fi
> >   }
> >
> > +function wait_for_file_value() {
> > +  local path=3D"$1"
> > +  local expect=3D"$2"
> > +  local max_tries=3D"120"
> > +
> > +  local i cur
>
> I would just move "cur" into the loop; I don't see a reason to print it
> on the error path when you printed the value on the last "Waiting" line?
>
>         local cur=3D"$(cat "$path")"

+1

>
> Also, not sure if you really need the "local i" here.
>
> What if the path does not exist, do we want to catch that earlier and
> bail out instead of letting "cat" fail here?

Yes, we can add a file check before the "cat" loop.

>
> > +  for ((i=3D1; i<=3Dmax_tries; i++)); do
> > +    cur=3D"$(cat "$path")"
> > +    if [[ "$cur" =3D=3D "$expect" ]]; then
> > +      return 0
> > +    fi
> > +    echo "Waiting for $path to become '$expect' (current: '$cur') (try=
 $i/$max_tries)"
> > +    sleep 0.5
>
> Any reason we don't go for the more intuitive "wait 1s" - max 60s wait?

Sure, the total loop time are same.

--=20
Regards,
Li Wang


