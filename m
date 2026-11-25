Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1C7606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cpNkbnLS
Received: by kanga.kvack.org (Postfix)
	id 5145A6B09EF; Wed, 25 Nov 2026 07:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4EC6B09F1; Wed, 25 Nov 2026 07:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B30A6B09F2; Wed, 25 Nov 2026 07:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 079D76B09EF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:44:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86ED9120AD4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:44:13 +0000 (UTC)
X-FDA: 85473609186.06.85ADA3D
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 78FF81C0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:44:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=cpNkbnLS;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of alex@amutable.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795610651;
	b=maTMkVouPv5YnCivvtuuM/wg81FQN4HYw15EW1KjNEpeCGxCknKrtAfQvUo9wbGB9RkvTa
	4Mk1n8pxiMMMD0GUtof15+xg/MDC4qFDcg+fJDsI/TWl2nwEqj4Y/G0yNHig4nqzXCjT/T
	BwI1rEOPFlSqBozVdFa1PE9Krw+m994=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795610651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3kRI1t8FC4sBJ1KlH6nbApPr67WWAzYu4YOF8wU9ro=;
	b=QBbeW8q8lFd/E9y0aTickcNwXd6df2yil1Bp0YrKZjW/ir1/CFFdXHnH5w0qIMVZnH/hSc
	A3R3un4/v03bsCKX/1yjkEGotmZJaU5fL6nK/NOnXmwqUzWf2NbjrL1HO5roi9oxMNAv1j
	1i7T/JMxlw/Z5BDDN/1ZItEcOwEuptU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=cpNkbnLS;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of alex@amutable.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a42b34e930so4972624f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795610650; x=1796215450; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=n3kRI1t8FC4sBJ1KlH6nbApPr67WWAzYu4YOF8wU9ro=;
        b=cpNkbnLScWfhV5UbZCQ4SKBqlA1O9qIY/x2rqxOLHcLuDHxEyhuQ1/mcQWBCOkaGl1
         TYctRHWuqzcAPS5DogIsGbecnJe38da3wRBxZ0ddxfKcO8R3McnEWRt7XsnB1nPR2Idg
         ddlw89XImYjwDk8lT+tvn7+hr8jUODYKW9s49L0DJJLMUeTwD+/CuUmf7grVwXZu3ZsE
         VaVAK20VxKw77C+gRjgpJljcRhQt4nwzP466djl1BRYwcvLYcKLA3ksC7By+OI3t/j6R
         V0r59w/LzcdPhz3hivSmDrmIV8btGKNqKk5CE7N2Jzixihr87kvuYTjtM+ijNrBg6O5A
         KiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610650; x=1796215450;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3kRI1t8FC4sBJ1KlH6nbApPr67WWAzYu4YOF8wU9ro=;
        b=FFJgQwjNT1Xw4eSbKGpbvcp+J4WxUr0MwRSorDgYfqsVpDPF1WGeKy3mww+r8peJa9
         RRAAMS71oRYzjku+7gAoG3eTeEwOWrBf6CkxpNdqggbkCuICtrI00C18XAcnMO1R85JP
         VM+k6wrwFtHTRgcdtBjJ20vOFtWkp7wNaJdrCy/mn5zbS5PED9CPR20WGygI2tZSM7eh
         5wxCO/MF7nMh0r8DDF04h5V7Drkuw4ybfWcMxH6Uj6z7xGVTVo4YSS7IA6PCB7kPycOX
         XO4aKsmHFxuWnPaTqa6AQqW3IA4MmQqJY1pr5K2QejKkLkZb6UrxNQ/tL7eGPneIyxjy
         Dy9A==
X-Forwarded-Encrypted: i=1; AL+hErEWzpI8wyFWnUMzmu93WLGDNY7hd41WepY2k4zpH94IZOIJjaI3gBJ1K5qRXtyDaGCnklMYhVzs9g==@kvack.org
X-Gm-Message-State: APuU4Z9pfla0qIyr/16Zv5SOddrtYiYeFSR6/4kw4XzKLk0+fpxYSgKZ
	9rHF/r87RfLMg6iSAO9FA5/HvT2MH1yD4IydI2plo2kzrl6zXjuryFCd/lT8dMjyT1sc
X-Gm-Gg: AZFdTZeI4tgQq7Yb2jIJLAQaGhmRC2POHzlfnKu6pVGPGrpNVYu/eLEb+O74WtuJyR7
	yXu5svGtNs3DOb1JiAni9NgqdixgdSkGOAh3bwAwGm1H67YNzOYvYsUmOAHMRX5YQNDaEhYy+tp
	yqFf1SKzUbsaGs8HpdJTSrlznz9S8Pihii8qhrdUlODEgxZ3Jm0CBKnexvOadIfQq0/hYD4mj9U
	houHlCZpvhRtd6txlSLg8d7PwOSMA1aZDSQnTe6M3wBOptEd89clWpPbZG+vQTaldvfm0mgKnsD
	0dqF3fukw6MVTHb9+UmGEAPN5uTH4JYjvZAq4+J5tLNX81A4a907bRkGnfMuVXTEBQIBIJsg6J/
	vzbk2cL4ax3wg62JpkPKxqWVQd4CFxJHPHoi7hWB2wcDAInhbjbGY5SLpsucSdImjLltmkQJ0IX
	gbsYiq3x3sE2+UjM6D+969O52ltGbGiTL6h/rEUhI7TJhWLU9zbOIsCVDt5yiCdJEBI8HQb7K/r
	cJBcj6vvc1RGHnmTR76zlogb7+n85ih7mhHChwNtiMVMg8hnWyDMrLcZWTdasvTofZfosbAjgYl
	l04LOBU7uY3EtD8oRfsP0Y0HJD2CATTePhqo8uRD/1VP7FLCACjAYCsKvpbb99HTM+583Hmn/Gd
	H5WjCKudIPysUwH2dN7vBykOPvUTugrfwzd4lKlB51I7noFiZ5ln/AZ4=
X-Received: by 2002:a5d:584f:0:b0:4b9:8ac3:f5fa with SMTP id ffacd0b85a97d-4b98ac3f6d5mr4714062f8f.48.1795610649431;
        Wed, 25 Nov 2026 04:44:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm38964871f8f.24.2026.11.25.04.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:44:08 -0800 (PST)
Message-ID: <e6c23984f7b47f9dcfffd6de2f6fdf75d07a14fe.camel@amutable.com>
Subject: Re: [PATCH v2 01/13] ovl: don't warn when the lazy lowerdata lookup
 fails in ovl_d_real()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org, 	stable@vger.kernel.org, Sashiko
 <sashiko-bot@kernel.org>
Date: Wed, 25 Nov 2026 13:44:07 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-1-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-1-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 78FF81C0005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xhckyfzrd6wiru3toty5ahm9dfxnchg3
X-HE-Tag: 1795610651-514649
X-HE-Meta: U2FsdGVkX1+0JhT3IsBLZW5KwZ75nsc1w/e00WGBZZbI7wpoJZji2MRGh5gJ/NLdkWH48K1M5cmYJjKy/6iT2+uIHhdddb6M569br64i3qk9kvcsDlKl0wtGGsHv+WLHCXvBybSl67AWE4Ix+znKkWmEe+eAfYT5D3bw33J2PPF8M6eDM6upf8DxHo0bidmLUihnx2+kFBiCJWbZRMCaafJm1+TbPUJJkYRmWsJ8k405+kUnjSCoF47/O88m66HaKRACQkf9oXsnhZ0PvKBaflDgpQ1t3Kii134n4RRtNCd4JqBo/Qqcn0fpBh5eNXgHeXNBgOUAttqOl1t+GXo4Dtr1AntD0NTt9gJxe2ljd2n5VI5QdMQvefoGGIcfyucN9ERBrXss47DohNebiS6BJZiNEGMEqhmEsqMFGSB9AQ1WR4Iuigm4uMWlKI6qMqxMMdDV4xOeW2/FC0ICNqykmUw827y3LY1W+a3jH/3Uhbmgzx/ZftRCT3iGPdehXCP0Xokis2qz2u6ny+Rnm1K9TSNECRVjpfg4toCpb74F+YNEQNMwslNG8HKVR6nr869QIgxksuv4+F5PwPrmuB66VTbC8wGcxHex2itKowKAkN64o5Qv4upM6dOolAZxhDAbWOsaDYbKDK+l3c8b/I8VVzerOgIOoLoN8sd+3T5T5aE6MGamuW09OaNoYvqwQZmo137U6DTeuM2o5BUO/fH2QvBEvjXRa1NMFW1hAVWVcpY19g+/CdB8vGZU4UW5cCdtNL8JSUY4keol657nxGfAfyVjvDJ7XAu+XdMEWfMlZcPrTu0JmQb9a9ZyHPWCvOcGJdA6YTb4ZOqtJeBcvVg+5VbutAFbVvJP2IlhlXBYMQoNuSYHnoYb/KoIGPQYQbI9HpUT7rTTvyYVRBhb2ATwou84cGkdxLfy870ML5sJdbPNvro9aKTVZJddFSRxqVEgG2M/OzQXRkR8yIOIVhY
 5l0aS4Dl
 8Wu0JY0M/k+C6UYpW27Du7eks2BC9O2oU4gZErove2PKf8f81Anmi+33fIQsaVFuDRJRN6C6Q/pHPfxTo7VA8fvJM/wpTBvmwOlB30lj2VBDUJC9IIrD2vWuWI9vO0TCXnLxy1eD7MW02R4Y92YpjSkWePT16R6MbWtjWlH47/sZHLYa3XRUJk3NvJd+vZxAXgJanPQKDwkzNy818P7oNRSQbDMFF8cXFqrlt5xcoE2wbf0s50TtWIFLuMxIlw+SwCXx9qvRzpaaj6xldiXeKsHZ6e0RsnnCalv/VPBc4ZLJrp4eawaILlwCkm99Krur1PfmCFdjIHCOKij1cAHWEBXvSSidw21Ro4AKm4q8a6WP6Dhx7OPefOUF01DTgPBgEyILMHKXHUYl2d7CnWcUy0zjHhe00m7SrXF3ePOnCsXErKizwXmwCFbyNtJtJb9LH830AGgyQJlAMuJl9M9S4mPYwgoy0xmY7ll8+MxQm/rvtw+lHE/W1yncZetD5Juz/OQt6hqKILIGesDrX9aQBuEloulVJiwzCc46BWS/cNHCWqKM+qdTUe4d0ozMnmyo9AHnqcjBGRvFrvx0rLr9edekYfWd/aaCWBnqRfj6B4mlsX7M8gsau/WHhXwcQwN5hdxvrT68P4mPeG2mCIVEUAsGDx4SoFzTDDAp/Ej4fsNZQbeCuOStgMFzmjTpmmvEdxWYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:43 +0100, Christian Brauner wrote:
> ovl_d_real() looks up the data of a metacopy file in a data-only
> layer
> itself if nothing has done that yet. If that lookup fails it WARN()s
> and
> returns the overlayfs dentry.
>=20
> Commit 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
> data-only layers") assumed that the file would be read before
> trace_uprobe places a uprobe on it so the data would be there
> already.
>=20
> But nothing actually guarantees that. trace_uprobe takes the path
> from
> kern_path() and calls d_real_inode() on it when the event is created
> and
> again when it is enabled. So a uprobe on a metacopy file whose
> redirect
> points at nothing warns twice:
>=20
> =C2=A0 ovl_d_real(/f, 0): real dentry not found
> =C2=A0 WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210, CPU#2:
> sh/279
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 <TASK>
> =C2=A0=C2=A0 __trace_uprobe_create+0x1869/0x25b0
> =C2=A0=C2=A0 trace_probe_create+0xcc/0xe0
> =C2=A0=C2=A0 dyn_event_create+0x46/0x70
> =C2=A0=C2=A0 create_or_delete_trace_uprobe+0x3c/0x70
> =C2=A0=C2=A0 trace_parse_run_command+0x1a6/0x320
> =C2=A0=C2=A0 vfs_write+0x1cd/0xfa0
> =C2=A0=C2=A0 ksys_write+0x116/0x250
> =C2=A0=C2=A0 do_syscall_64+0x10e/0x5e0
> =C2=A0=C2=A0 entry_SYSCALL_64_after_hwframe+0x77/0x7f
> =C2=A0=C2=A0 </TASK>
>=20
> bpf's uprobe_multi does the same.
>=20
> A failed lookup isn't a bug though. The data can be missing, its
> verity
> digest can be wrong or a signal can interrupt the wait for the inode
> lock. ovl_open() simply fails in that case and
> ovl_maybe_lookup_lowerdata() already warns ratelimited about failed
> lookups. So return the overlayfs dentry without warning. That's what
> the
> WARN() path returned anyway.
>=20
> Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
> data-only layers")
> Cc: stable@vger.kernel.org=C2=A0# v6.5+
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
> Reported-by: Chris Down <chris@chrisdown.name>
> Closes:
> https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chrisdown.nam=
e
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/overlayfs/super.c | 10 ++++------
> =C2=A01 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 08695a99f4f93..1985b553a47b7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -58,15 +58,13 @@ static struct dentry *ovl_d_real(struct dentry
> *dentry, enum d_real_type type)
> =C2=A0
> =C2=A0	/*
> =C2=A0	 * Best effort lazy lookup of lowerdata for D_REAL_DATA case
> to return
> -	 * the real lowerdata dentry.=C2=A0 The only current caller of
> d_real() with
> -	 * D_REAL_DATA is d_real_inode() from trace_uprobe and this
> caller is
> -	 * likely going to be followed reading from the file, before
> placing
> -	 * uprobes on offset within the file, so lowerdata should be
> available
> -	 * when setting the uprobe.
> +	 * the real lowerdata dentry. Callers may ask for files that
> were never
> +	 * opened, e.g. for uprobes or O_PATH files, so the lookup
> can fail
> +	 * here. Return the overlayfs dentry then.
> =C2=A0	 */
> =C2=A0	err =3D ovl_verify_lowerdata(dentry);
> =C2=A0	if (err)
> -		goto bug;
> +		return dentry;
> =C2=A0	lower =3D ovl_dentry_lowerdata(dentry);
> =C2=A0	if (!lower)
> =C2=A0		goto bug;

