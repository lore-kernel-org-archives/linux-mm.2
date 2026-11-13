Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED918606A897
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d5ak/0K/
Received: by kanga.kvack.org (Postfix)
	id 045076B065C; Thu, 12 Nov 2026 22:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C266B065D; Thu, 12 Nov 2026 22:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76056B065E; Thu, 12 Nov 2026 22:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C27BC6B065C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:13:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 438F7A03A1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:13:56 +0000 (UTC)
X-FDA: 85428626472.25.20FE71E
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4CD1C20003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:13:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="d5ak/0K/";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7cNQ/YZaMN6lII1BbBbVlNBX/05rEUMzyowuYGYqyg=;
	b=W3L6OtCDIcir3Jb6CLQnIy8avuAEzfUhGLc9dV0scKqe35qsAZFiH7BtGEDv0PPe7K0g9w
	OJGGUdInLqz5+/+ru7zCfDdzmqGmewRPnZdzTNG8a3ew21BqlnPg6n4SW3mkPfeYR/78+R
	A99VTDkrvYB4qfiBD32yBFANdsErTxo=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="d5ak/0K/";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794539634;
	b=XPDyNSN8LP3iJ4BovVfc+RT+MCLpjIGAKZ1zjuqjxPii7FGyj/gu3T4uKvv8yYmuc/V4CJ
	PCHamP3lPH8QSO2xOtT6KZVYpty4Osc/eSFBzwpjWuHArPMXrWzgT6FZDPkqAZl2SJrHaw
	4MIEnYIygEirE0EE+NfXC9frDFpELLY=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5383c97c8cfso104651cf.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:13:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794539633; cv=none;
        d=google.com; s=arc-20260327;
        b=nqIOb3gFIhPJCU3QTnVsaD0ctYr7LPmUcOqfjyN80a4aCdgFeiC43v/uH/U3h7fbZ5
         +Rig3Yx+NIR0PtKGAAs1URaPe02kfKkYMt935IWF3K8+FzfqNs4xkjEMz4e9AzZg5027
         yZV1sP40JXf7Dpvuj98XZbyfkulJO4OYccwK2S50zc3wQYPAep5qIjbLkGU8FSC4pLtD
         vcaL+7shCk/VxG/2UPVSHEZ/Ljxt2yQTVgl0JJdP28+AmylRiCS8f1JmcviAkFKsYhc6
         dkwpH18wNP37B16Jr6qjMyzCvx1+appAgA2navZ/Rp4/yyYfP0NuMg3Cf+nruJCmo1pV
         qmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g7cNQ/YZaMN6lII1BbBbVlNBX/05rEUMzyowuYGYqyg=;
        fh=GvO039+ghDvc58662F8Fa1buj8swNc8fRHGO6ECAvqI=;
        b=mq+9xFqY48uq+nkh2aYiF/4Uvql0HUDMIfWsgGNYcq0P0bNhS99PLn/JxZgdGMrehv
         tcnCajWkWVsdUbHQpe6IBR6i1paU8WL6ZjAt1Mln3/29fu+c5aK+YLGOaohAjditHHHy
         MVpkIvt5CXgcwMXiDpEhvnAAY/o9+eX4GN7/ybcKhAzzvlRFuBkZQKbRRXf2F/FWan0/
         DtUiYJZIGSyTzmwy89p8PrBDVRqoWPwuijfhcsi00Fx7/uaIvoFMspdH1QO6esfo/lst
         5aZ8jHrlhaOv0tm0PyX7fQySrk/1nnYuZn0wL9r7MIOnB0D6iNgI8+2RYWLUr/IxeYEC
         TJnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794539633; x=1795144433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g7cNQ/YZaMN6lII1BbBbVlNBX/05rEUMzyowuYGYqyg=;
        b=d5ak/0K/fP8PByzbAFs/eroKUW1GZCAIsncSgF1+krPqhlxdF0XmlfB56cHGu8pw/6
         Yr0l6cYARNBrmyPGX11URA7U80hfKuXfmUFJm5576m01k6PfVj3kUKSse7CikwG1ZwUE
         kkmmem8SzPjLvKKtgYtm65FXniv/CipRwggoCmSlf4eBsU39VyvpiG4Iox0OjlJXYcNB
         szCtYG21hAj1WJQC4hVXt5edPRm+t9wnHjGje6vFoDXYfTUUfUvZ8e2/tIe8Qn920Dui
         0C0mC+lB0Iw9JfatVtMXAyejttnfwBCIB91YkSafKFlQ+AynBgy+MsjSU5w243Qgi+vo
         XwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794539633; x=1795144433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g7cNQ/YZaMN6lII1BbBbVlNBX/05rEUMzyowuYGYqyg=;
        b=cPm3s2AQgQqhkf0qCNpr2IU+LkgECvVviZNRY3EqR694J61khj9tWkDZzanKPWmy5d
         lY9vIkCaDASzBJUwZvWIyxS8yKmhM5grfQgb0cmYWTyEjhADFru3nfd0eENofzoPaB9P
         NcPf0EFcLKAAsoSwV0gimTpp0s1hYOH4qzG4Ed7O6iS6iZf6NCLkkbG/UzInfg2jdTzm
         dV0ju1Dm5/WVxHAeTtLgQP7P3UR4/JbN4iz2zF9UKTXp6WrupA+iVD1CJBUYPhpA9HjI
         +7HvOno/G/6wEm6/HvYQBUFCxyNZprlhr7lnN8qsauzOjme8yp/WXmIoUPmZEExnrRAI
         t2Hg==
X-Forwarded-Encrypted: i=1; AL+hErGqdP9PkHVACnKzmvpdpLYFcWpHfhS+Mzw2AALGVRYM7QASpjINEA7sVT409L8lz5SgyRqd/1zYew==@kvack.org
X-Gm-Message-State: APuU4Z+EOy+yO0L2GmYaKbld/sbvdlmeQvVbeQTGWMmemA3W+OdULlWf
	9BewfIT7u5FVriXmntI0TxlJCld+8FaQOUBOhB7adLCZr9LO5JPz4V/lWG19YonLjAM7zDVLsLh
	aQG1zXnmj1jLcegvbs/mhndUjtfvvLteSTqUWt9jt
X-Gm-Gg: AYBFou3MzIsk4D6x33nKpsFDjVW9n4lbj/vI0B0+WqKqx3+Y4b8DJPdVFY7zKVHuvpW
	BEUd2Rcfz008DbE7HAcn9ySKDh+SN517SC775/888nhPC1LKmzTrOmGP2ex1ipsfMeph78zURir
	1PqzEeZoFKZjBsXKwEF1mDWIIqXlNk+l2qEIO5HRRpDjojYZiAJn9IhmgFNu3XsXxIVKy8EJPBz
	uNoIpFMtjtm5dSMjBMDz3EhQUCie9MqX21JTVdl2NkPNyvdNNvX2NS8KnW7jXhubzmJK/J3/vSQ
	OL2xtD4fqomY6qXIHzjwLsCy9pEX74z4t3R2JQlYkSSVZjbIGAWLJ2EJZKxrGrOwU1uxOdjYAP8
	KvMNKP0PFcSPCXguuqtPDB14jnCDtk0Qwir0HbxH/G5asgQv2a0w2dE5hp/6ZP2qrMYYgTp0=
X-Received: by 2002:a05:622a:4c06:b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-55b32ae7d17mr2934621cf.14.1794539632682; Thu, 12 Nov 2026
 19:13:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112140101.647-1-adrianhuang0701@gmail.com> <20261112183727.68afda9533aff699eea12cdd@linux-foundation.org>
In-Reply-To: <20261112183727.68afda9533aff699eea12cdd@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 19:13:40 -0800
X-Gm-Features: AclHuK-5_bVJBffNEkLm33nopZ4Y4fegU-viRnI-qvcSPbYgKaZRfYUy-9POop4
Message-ID: <CAJuCfpEqQQb1_UkWH50tgbdVz9KZ2anfCGWsvvoYFsnC_KHcjg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CD1C20003
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: xwtfzd5h5e5d7xmsk7ahqcfdx4zue3rr
X-HE-Tag: 1794539634-987894
X-HE-Meta: U2FsdGVkX1+GQFvExxK0kw9jIQACwIWuevEqJ9tkPCm/qKqX1D4MwDWCj+uhWqdQh3O5gUen1vDH9L5EHmDjqTa8PtW90S2zcO7UVKrwWR1y5Z7lVWIvU0A+cg/kMGFJRxwCIXztloVycMTpEE+4B/qzkVpw8IH+yU8bErEZiuuQM5uSJeNJdT9rfMZ+BsNiEREsUbrYNPBiPol4433igN/jMHx9dqhUU1Foyx8bWInULjef+qVVDQ+241k8Odf3hTa+/gJ7OkUFNuKyPPrtlUiqO8Tdgv6KffkbbprMR1sRFb0b7SjdcPF2CD1vAL3bzSjI5GDiu6O3P6zBpHHJklZsuqnD/xmVwDrISlwtYg8IpkNL7NMGzu8flPdgw2wYw5BF8x1dMCE64l3mrAIcVOwjQrnfYV90nCyPAe/8bYZ1m4mYDIJ9Kjve3t33IjvVC5i/ujg2DjnmU78w0uxnR0pTFpeYawB2Tznk9XzHnJf7LTAodz8d0P+gW3iuEuxGrhX6DsiOeTNPlnFDxfwJ9bCvbB6p2X0ne7EkYfmzfSvUiSk7VG8lWPgTmE06GlaefMdmbOks2wg4F1m7uc4zY/Ij4JF/LdpYu6fIXDNSsSj0yz2G1w0CeURJyl95PEhPGsXq86kjULRgA3vkgPFg+N+f7zxSVTrIVHjO0kjabB6Jqh3ak7DlalVC441QPC+0OPySr/Rku6GtyOkUPnZ85ZhnfIynjSGP2bkHrmqMo/9qRTqPyGWmseHWiMo9K9V8+glRSKK6U9sQcPW1/k1Zfc1Jn3DrCN/OLonpgq1bZKsY0MpMqI9MeeI9sOzGeYCnOEf7X4Sw5ZQYl6SF5akmIeQwLwLkFKbOj0TuD2d87VKJOnXhr2X+lpnrT8MMJ0kj/FtQN3qNUm492j5dRIEtceIdXNrxaRbC/azuFCtIkvOCWOZR74SrhayTYlfL3AtIQc9DAJ6mVX8CR94yQ/9
 pe+THmHx
 KSMDOKD3Sv/dyf28+chlawr+NCLBNBqXvWW0E4QuXxWduhvrCP5/CBvV22OwGX9bNMIYEX4jPA2+il4qTYVfYZ9zj7J4OYKz9hhHfvNN7/HSxs2EbUY2i2hYtzSdChzngcg0pSp9W5R3sBEs7Xot3dIkUBBdJ6HFjBXKOLcnUL2q1rR66Gg71HcVZzkeT1jo0rtMpWsN7ipnBAWfTIegCIoSdm4UhmHxJwaxLtJID9t74lzpMUIUv3xbPo/4sb5j8ciDMkzm2tpShM6moZl7bDDW9b7RqDMBj3kkTaVEL5uKX2r5exR6mAio8H8ujcqjHH13eM0Xfu0C2AkTN6veB3Dow490vLnyAg9+rSDNpcwLVHYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 6:37=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 12 Nov 2026 22:01:01 +0800 "Adrian Huang (Lenovo)" <adrianhuang07=
01@gmail.com> wrote:
>
> > Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> > per-vma lock") introduced the possibility of returning -EINTR
> > from proc_get_vma() when the VMA lookup is interrupted.
>
> OK, but what's causing the interruption?
>
> > When this happens in m_next(), proc_get_vma() returns an error
> > pointer without updating the position index. Consequently,
> > seq_read_iter() reports:
> >
> >   seq_file: buggy .next function m_next did not update position index
> >
> > The above buggy message is reproduced by the following command:
> >
> >   # stress-ng --vma 0 -t 60
>
> afaict "stress-ng -t" can send SIGALRM, but mmap_read_lock_killable()
> only responds to fatal signals.
>
> So please clarify: exactly what is causing this to happen?

Also I don't think stress-ng --vma 0 -t 60 command reads maps, smaps
or smaps_rollup files by itself but I might be mistaken. It would be
nice to get more details on how this gets reproduced.

>
>

