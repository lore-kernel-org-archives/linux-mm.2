Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B37F606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=klKGoo5s
Received: by kanga.kvack.org (Postfix)
	id 7AE236B05B2; Sun, 25 Oct 2026 21:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E0C6B05B3; Sun, 25 Oct 2026 21:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E1F6B05B4; Sun, 25 Oct 2026 21:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 311616B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:17:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83B4D120416
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:17:30 +0000 (UTC)
X-FDA: 85363014660.24.21C45EA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8736B40008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:17:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=klKGoo5s;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792977448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JHKNZG3E5vHMpYqgouUpuv8xtxZ/WRsL+FJ8mE54ZM=;
	b=omx6kR2GVjUCsnZaseVlivP2jTlU+pOjZ1VuveVJylkELs3eyRu/geCRHD0sFrfcNvLuIj
	WDfo0dTytKm+dR30qSkPJB2MYkDIpvOCNsHPMNJkUBp/K8wwpEgsgyZ4F5Ki/BgnouZPDM
	3EBVCul9K+nFChlJjKXH+mFkNGFVmw8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=klKGoo5s;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792977448;
	b=vayYrLTZxU93bqHBJoEl90vLkm2c7CeZM2pgqXPA4RRGbrA7uVBE4k14Lun2V0kz+xJwXM
	g+Is6lEfhrhnRmOE85PvBy/UlX7qQ7gU2cgaHrIs+NnvX+pKrbACrwDyhguUPiPYWXT2Y5
	+IOe20cCbwD5NxQBKQfnZ4UFKdr28JU=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so4343708a12.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792977447; cv=none;
        d=google.com; s=arc-20260327;
        b=B99P1OLc6aJqnGzKV9UH25U7TaBFGDW4Pyvzy8xzXUOWbCpJLxNZC4JTggPmNhA3vn
         wkFy2BE8dYkIxzgD0VFrjm1MYrnoZSuzZtl73iyxGD1aEQhLWXQiPlIrll+jo03AlFOy
         TBxK4J5GyjhSTt61J44oa7FhvYjyBiEtapmatxJIJzm4v0fmZjyU0P8FRwUZQ35hywar
         +hjc3RKsCtLcctWlW5uq80H/5c5RyrF4Hlv07oiTGo7fxbWk+2EJDg+TNxGY3IDdbMDB
         f9JoynsrR4Jtk35f/k8Hwm39PvIio9wzSHja4CGp+1Ul9pI+6ICnM1Q5zKg771LG2wSX
         Y+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3JHKNZG3E5vHMpYqgouUpuv8xtxZ/WRsL+FJ8mE54ZM=;
        fh=ZXOK7wJix9vM3DXoiomb4tqIVKbxQj71c54X+83cpyE=;
        b=R+KbjrkwBdLgWIoD8nJZ7uaX2LgYzpLv5Cg4QynhkRYvLOZx/pK3vzQ0I/XJevdvjv
         8evWFrE6VDRIo/vGJ0HqDBvi4DzDbxO9zrJOmaqCpPZyMN3nCFQuj9gKkGXEImEslGwi
         iCKxKoBabjpDxxQWF2hCi++h5m4fLUgm0AAwEezV6LZB8CenI7ew58U8+Ctm8ua0cS6X
         aT9Z1QU9TEXJCRqP2o5w+z1B+EYPqP3V3DE91V7OvX4CLINaAgLdlMHk+sg0QjqrB5Hi
         UFbiWCOFsyKMQJI92RJFb/Nlrx5J7LyBtBTbY8BMuXykzgCkNmobePE5P7VDrfMa9mQN
         FnDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792977447; x=1793582247; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3JHKNZG3E5vHMpYqgouUpuv8xtxZ/WRsL+FJ8mE54ZM=;
        b=klKGoo5sAVNhf0eQv2tQqFJhiUxYJRT8Wey3wpa4woHMYgLkIIuTrSIP8UVRQYEV7Y
         EDw8mzopKhp6EjzUgKAyQ0yluCyAr5O24oMGZ7g9idwRa8hCAokd83TpJnGt1/vR1rcb
         tv/9znChpbXacXFhBJ8bMbxsfnn/ET9OlxQJx4BvZXI7SqFrmIxYDYaa0p6SbmyA1uFJ
         yOZ4Tv+bmmA4Y4n2RcrOj4y14ofrT6pd/EJitZ4jmzKSWcaYN/RPV4Pgs3TC553WGPxG
         LBzgfyabNxVFNIisu07tv0phxzuICZC5mw+5DexkXloLcerL6DFGOkiuWBcY4epHrHwJ
         Gv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792977447; x=1793582247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3JHKNZG3E5vHMpYqgouUpuv8xtxZ/WRsL+FJ8mE54ZM=;
        b=hOC35H0DYuoRFD7Y6Ou88e+ZZOW6ap5uQxWCBo7niIeslSd1pUky/NynzFq8GNpQ0D
         hahOxA81Ik1oViK8tMDlLcbwtGED3sPxoyLp5ObO+TWL7Hnlh+DBnGrGJ3Q66QBgDe/6
         Q8VaC55XrmOyFKZyvsMtiEcvz06AZyxVRvp8jhbVeLwb2CCdJQOikAPwjZlYXMwrcrvx
         F05UJw/WcJ4DzNIbVQwEWyVl0BkRxOYO27AQ3lHQWLsarxIp/AMDjbkP6nG9OJ5qxvZA
         DARqx/dyTwwHeCXwLquW9rvw41/ZJbj/5UTzQcutkSaGWEaI0vsFEpZLgV5DfwwDZMzW
         f0cw==
X-Forwarded-Encrypted: i=1; AKwUvBw0OLMHNRy1veB5cmz4vzclfpAbNxLTfjiTV1zgHPRHpW/+vwJw8LWGTit/JofK2HLnWowfWSHE7Q==@kvack.org
X-Gm-Message-State: AFq9FYJGpZtqXNU8enzIjDiopaKuffQ+Nu/jIbvUqiVbNo2cm0J/Q/Yq
	rKTa9b/HaSBPd8VKxZ0rnpIdAk46k6GTDnm3NTk8yqocoFoPu84bOamXpjaHSdIH+hFfDUXMygu
	+Y4gnxCQul4QAIqtBBVxPaxOKgbTBY0y7dHnjHOTwTQ==
X-Gm-Gg: AYBFou0Jyck5wSE6zIAwbtsNQE05T6aZH1GVI1/pLvd9FiNIQ3B3tXrirzuTxGXdGdN
	2CavzRqgQ3zB2tPZjQCjG7A54Ww2pyXpZjddMLmpWjIMj3zaaCops65eDQevvAHzfXrb8Y5hKnr
	vt8T37r+QtoDLBQP8qFLA59WfQJJMeZXRk3Vpcait/WEsJZQIVxGtsX1ygz1acbsJ1MN4srsDsY
	rxB0rHzSOFvUzCzvtU8GEaz9Yu75QZnazmJS55Wv0O3yKvFwS38K2sTslMr+bladmeyEzl/OULp
	b77MWyeXQHW2XbznaesEiweOFVbrjgsZ4MkAD2HXg/v7Iy6Fm5kBONvBL90j91COXLhcNvc8qQD
	MsSSBZiHO03T9emFln/tQ8KxHatUdd+RrvdO3JGk3Uve8/jZJGWhyNksjif0qe7VrLo9L
X-Received: by 2002:a05:6402:234e:b0:6b4:31c5:bb2b with SMTP id
 4fb4d7f45d1cf-6b4430016b5mr6666492a12.41.1792977447040; Sun, 25 Oct 2026
 18:17:27 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
 <20261020144710.4154339-3-pasha.tatashin@soleen.com> <atsM_WTjuZNl1EGG@kernel.org>
In-Reply-To: <atsM_WTjuZNl1EGG@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 25 Oct 2026 21:16:50 -0400
X-Gm-Features: AclHuK98Gj1W6ZSJdFU1t2f67xVGq0_oZ919Xy4QT-Ox4HmUEuoqqii467TmLm8
Message-ID: <CA+CK2bBXCPBiZ+ek3+PiOHR_8obXkpJmJ=iqcXC4kxO23b8yuA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8736B40008
X-Stat-Signature: yo86eypzu7hi4j6oi9q4xj8nnkjt1841
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792977448-177919
X-HE-Meta: U2FsdGVkX19JFeBd1IHLSrAFt7eDDt8iV0KZ9+axWttx1uxTwqvDl1oYXpqeXGTnW8Z+0i1vGdDLMWS2x0nOLN71O0bvwiP89U0ViI/B0rSGZSKAWfjViYBmImKvh1B0Dt3inRjGdZ9C8w1ASP9UiCMzGI4y2WfCpMUoaR2lJocKUxEgsYLbg6rt+SmSqr+1N8s4libeBrRh3uogkPAb1V0qXwRaMNFtIF9mh+6lZLOrKLKPzAsX1N9O2aLXbb2DlCmnAJkJRAvzgfGDDGsnzgMhe9hKQQkSSfd72/9fX3dUVQW/HmDte4TVNsOZjqFJ8ERD5i+pkOyCuaA96iH6ku/7F3ll9Cgp2gc6H5NTCKFeeNFBrmzF0c23kVE03ZQc8+C+tUJG9nCaKFKd3TtrQcTNZGFOLZSE04hR+HjumHyuCptbGqGWdoq2/F6Y7IYiTaNQPNJEUG7a9JRq9/aAgIoueWhI+X2Iy2th49JAZpWcMPBM9UYcNhEO4MOh7BNliW9u+IJziar7HXZsHe2tynor3u4UUgclVk3fWnsW7pLTI5AAqn1VlsZ4GTnDHRqL76yEnwY8CDPJjQ0JnhWmLHExi7lh5XXLfO58GN7hR0Dwi5h7O6UV8npQt0U9+aNntLvIsv+Wp6Yogaxa0OZdOL1sdTrIiqbQXgALDOc6nxmrZvfJWMbL8GEyPpkGLzcsBCwpl0IHBhToFRsbYwvifVXav/w4VmLL6q6MWGxB7Wdfy+x1DnADt1NEa4vai7s0NwmNTKlYU7bW5nLNb4asSVA2LGbimje+t8P71aT5MOEaozDfggw/eiIlSDwJhx5u5g/NcbszYYkppwiL8z93pJzvo2MVsfpkFwMtbrdf5apidzq1SZt/cjCTH9BQE+4EvTTYn7pyaIyGLBFrINqEImz0BZ6gEFikNPAaaE0jAV7Y9Mbu7UxOqOaIR7lfyr7WKWBUljRYRSKOG0ZKgU3
 V6mUb61x
 aSeeQqs34IGojtRUp+flhlFM5gUPK2vyY9aDnh6TEx41Adl9EjOSEKhNhgjiZryneIhCUvct3loxpvmCOZHDYPmmGNZtBHiGeiIGu85mI+FY8QhI+NL8lLfZqN7tihfanJ/EY1d5Ou5sjVqLRsaMIP2SCnSLv8b6ARNjk6RlSQxFn02hD4Be4wSc+63kf2g1OEKaZhA6iOO3ryzOqJwql/FO5E4pQbMjvgz7D2ofbUgSqS+HXOqWKm3sDxprRZNiIeHy8j8RLh9k3IFrllkyVmUehJWJ8za4hPF2W5Yo6S61JCUzoqE4b17GtXjVM3trZu5CP0XdrCrcX3ngmeXi/dNsrzHgQJtIlUW4E+OM/hq2uWC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 3:30=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Oct 20, 2026 at 10:47:04AM -0400, Pasha Tatashin wrote:
> > Provide luo_session_freeze() in the liveupdate test library and add uni=
t
> > tests in liveupdate.c covering the LIVEUPDATE_SESSION_FREEZE ioctl. The
> > tests verify that non-zero reserved bits are rejected with -EINVAL, an
> > outgoing session with preserved files can be frozen early, freezing an
> > already frozen session returns -EBUSY, and attempting to preserve an
> > additional file descriptor into a frozen session fails with -EBUSY.
>
> Please teach your LLM to use shorter paragraphs :)

For selftests, I usually let it express itself :-)))

>
> Do we need the entire list of what the test checks in the changelog?

Will fix.

>
> > Also freeze the test session early in luo_kexec_simple.c to exercise
> > LIVEUPDATE_SESSION_FREEZE across a kexec reboot, and verify that
> > attempting to freeze a retrieved incoming session returns -EINVAL.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  .../liveupdate/lib/include/libliveupdate.h    |  1 +
> >  .../selftests/liveupdate/lib/lu_utils.c       | 10 ++++
> >  .../testing/selftests/liveupdate/liveupdate.c | 49 +++++++++++++++++++
> >  .../selftests/liveupdate/luo_kexec_simple.c   |  8 +++
> >  4 files changed, 68 insertions(+)
>
> --
> Sincerely yours,
> Mike.

