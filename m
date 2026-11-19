Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9396606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=XcW/FRZD
Received: by kanga.kvack.org (Postfix)
	id 5C89A6B05C1; Thu, 19 Nov 2026 09:54:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FA86B0614; Thu, 19 Nov 2026 09:54:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4678D6B0678; Thu, 19 Nov 2026 09:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBA66B05C1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:54:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB64040AE9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:54:32 +0000 (UTC)
X-FDA: 85452164784.06.D7EDD41
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF6E8100008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:54:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="XcW/FRZD";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795100070;
	b=HLc7ClleMbMTs6ptlg9jHcQx27WfnWuas0cItGGxk7pM8+akbuvihWfEQO0cMrfHXA+olC
	EtNk4LTMb2YS4FnEgF5s/Tmb1oL5tLARiu7jaL8aUn0/JOmuAKyagjDK74BsVnHbqUkyaa
	0neKAnGKvckrl67YBpEdyVj71WTMeJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795100070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mF/CN1MwkKAbj0n+aog+XXJlGwsq4jMzPf88n15fnBI=;
	b=V0+64wA7982YM0lE0fQOWPu5nMrY+Dz4dYL+THQP7/D66Fu5Cc5qIMWas+vr3dLpTNokbF
	aAtJKwTOeqSq4i3Vsco/DxbokCz7pvEEK6SyFD5FTASeZrztaIA64G3mLMK0dm1zHwW61a
	+CKEnV+iLZo/OIHiosdq9BXBIsN5828=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="XcW/FRZD";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f3c616c84so208770585a.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795100070; x=1795704870; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mF/CN1MwkKAbj0n+aog+XXJlGwsq4jMzPf88n15fnBI=;
        b=XcW/FRZDHh03FhxBv4hBmvvclFjPQSBQKXX5QYlZyA5tfxvssDgnBp1uhOOt0EnjD1
         X7PPjnQ7i38vFazZ2iZvWm2IMXq14/J2nv3s7nbxx0YccZALDqtH3jTMLvAK0cGvFqXs
         SyXscr3SgT8sOZeR9HeZqSwpLZMnZ2En2Dl1tyfIX70qqCP7nB5DPiSSilAJF0WAB6Nl
         OhdN45grjiTsnPANEB8pNpkLoJ+NGwPx+my4KfCwVnYXBB5oTE+DzxuLvgmzmDLE4Th2
         9VEkdvQA2AxJJWnNrkHJsQ3Se0X+SnS6mhO2hi21qSRvzeepXLw+6p2mdOBoxfYmPdGI
         rSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795100070; x=1795704870;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mF/CN1MwkKAbj0n+aog+XXJlGwsq4jMzPf88n15fnBI=;
        b=zNH5QtJh4GVNZcWf/BDmpnEPD9t9fwDEwna/ZTEj5KPp7antTNBg07ppyfy/bhk2Up
         LZcZtPBV5CAZMuBNRHPt6O4r2XIPhsdYzAd/gI8aZZM74+YFXs3Glcpvvuht3oRTxhs5
         j1jcVQYh+CwIPvsJ+pcCL3lj2oR5ENuw0oXHB540UDTjEluLFPQqs6J9zlgAoXTF5Tff
         4I9/l1dFo2SLAZAOiL/WyKISkDz/OL3dixZ4acPQT0VpG04+WbGTpum4qnASDyI8YyfM
         ptXGLdmu4J5p+dld7Rqebj9iwv3Sr1blsTXCu89mmKNqxgwMdXfIiqxtyL3PiYKT41my
         forQ==
X-Forwarded-Encrypted: i=1; AL+hErG7W9j4+IUXMMKze97mL270nnhteNEyvCuMCUTc0PDh33TcAz62zJVygnfIwsA0LzBjBOzyD8VhDg==@kvack.org
X-Gm-Message-State: APuU4Z/K2PMGv2gpjdflccvXAZsboPwVH4/heZldpRHg1Hv3zTlTqPc0
	eRl8lDiFZ4N4n2xGX+g+RkOREWCpAyEV04efSTBfK79VZFugyxIOg6hJuOa3Hb6GFhQ=
X-Gm-Gg: AYBFou3Xuo2Vv92ImLh12tiXz3Ti8BA8f0w3PKhLRrhj5udKvKJvH1gZk85Baz688q3
	QXfLKHkOcZtrSF9fqIIah29eHQw2ERw4cVxexZ38ik+ZiQlWS0qGTIdz2jxtjbFvhEjkgGc0QY6
	je2Tp7LfsKn9nxiMJebPg3ryOIHMqQb6Il25eSCbFwtdJnGVj4Rdp7J0mnxyDkkPhvCDV7RQPeW
	4RC5GbGKZ+NlTi1dQdZR7DgBNsfgfMVU4hR2fshr6jOGjvgNAj+WwoK1EP2dnMShE/AVhYf5WeJ
	BfKO4OuubTdwH/GbdrpvXY6vqQl2VxZ/TM5MhStVH2HEP0GID8knDA8pjydS3lRrCMw2TyXtjIk
	xFi7m+UHlEI0zE+O0eE4pzxaHACsNPJjppaKqWC/WZUQnBjo2KTMdZnccuS2sDuGSZk7zn5XDl0
	rrUXR3dsZdsHhd2l7Me/ukTJlsn5XcUNs0eRdSuqfRH/ACysYgMkX3G8BLy7X90QJUm1RHjl81F
	CRWgXrzQkQvdMDKNxBgoXBV0MF2uinbA2zRP4HXhoHvB+et63gOow+C5F/nWr7LbY3dUxXpG0jQ
	hVEZ8Y8YPtq+eBhFpHMj+l3wYekBmGLGKzLtUk5DEwONuADndD7GiXbNyW8XzUjH0Wx90bEvFh4
	M6u0rNXzllfce6+7RC3TZ7HxXOkOWEGc=
X-Received: by 2002:a05:620a:6e84:20b0:949:a7d0:e6b4 with SMTP id af79cd13be357-949a7d0e7f1mr416234385a.51.1795100068869;
        Thu, 19 Nov 2026 06:54:28 -0800 (PST)
Received: from localhost (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949b9a5370dsm10296885a.23.2026.11.19.06.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 06:54:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 09:54:27 -0500
Message-Id: <DMZ9V6MU9XNZ.3J23SCKTSDHB@soleen.com>
To: "Chris Down" <chris@chrisdown.name>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>
Cc: "Breno Leitao" <leitao@debian.org>, "Alexander Graf" <graf@amazon.com>,
 "Baoquan He" <baoquan.he@linux.dev>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>, <kexec@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <kernel-team@meta.com>
Subject: Re: [PATCH 1/9] kho: Reclaim the metadata page left reserved after
 kexec
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <cover.1794383544.git.chris@chrisdown.name>
 <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
In-Reply-To: <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BF6E8100008
X-Stat-Signature: twrf993cmhtrpm6un6x6jnn95fbg9idf
X-HE-Tag: 1795100070-462521
X-HE-Meta: U2FsdGVkX19dnHSJWkErnoVPqqqR4s2kiPAASFS2MOlmRCJh8Z70TUdhgqef3J4yv/M+kCMjTNg7qY3i4pn8oe/3UW2ehCk8A/OGDrM58vYOPdTbxYmLmEylndvRWQC548h3ccQzig+HpuolP7NAc2E0a9avtAGOCHGK2Jf3PKxSyikqsfzkgO54j1dBwBqewh2D+hKYlW51qn4i/D8eSkWJjgIOIUImcTkLfr/iOcAflNieSAgAvyP1AAatfR8XAChSgp1OefGD1d5MSN7m8iHsxjRqgjtadebv/S4IPCsiLdmCP7fxGxGCES5FGSFOuufiORpKIPtEc0F604fvFDzKwA/g2FiX1H5M3MQVvNJkrvudW/jxojUxh7rVN0K9s1yOjay2+XK3VMfXpH5X3QEnMWPCzOW0F2AeOWKc+FMgOzWtthnZA6qxZJVbKLimYfo7H1hi8ix1XDaem7V8GrUO7yRsOCsrmC5t6EE+Rpl/9O8USBwffQFdANFaLBO1f8a6D8uxiLP6FMa7WiVk4pL8vS4CP+CDnfkX3HZu4nedP4LhFBA/CROJBsXT4mvuPf0cpRKYG+BxuMNr8T3OAjY3EoxC92T1v4SJP8mv6cz20V3CGcPs++3tU79FGj5bOK8g67+TQubdtb5w3gx/BC77RpTjCBhH0q3Wxbd81ClFvHRSofLzLOHA82zbh6772usswlPNmpOdZLFfqAfdCNYS/zp03+Fv8oocBFgdMWnNEQreky0fZhN1cTTmiy5HNTNOQOhw58oy7FFYwhXozZtVqd6ys3L6hv/R0wb1Sf2t0bu30+Eog/cZ0+Ysi8UfTk9pd47tcMP7AtMrmTl0GoNMmvs46eqFS4EhfGPJYAk6mnhcn4Nny9fK6+Vk8RoOiNqejlUNIEHJuix4ULFHNHR1LINj4Nlstnu+TDAD9GrMPtKYBpHOLcN0cWcrAiH0Q0ssj9a6AK0suh9ceBr
 aqw2MyFl
 RsbAEXJZJPL6k0yDsLgRyNZ3y3rhjhc5YqekmnvIH1Kn7yXQ1EB5HKWVt5EJNCli8XGprVmmcHlpy/acYSmo2FIB7MFXNNks9noje0webftq6A47U35RJLBQl4raSpDoZs/Yuc1YrE/1U37Co5GYs01g8D0T0QZhKU751rniSx/gjmFyl2GcZ/4eYRBDQCYgL+jjh8yDyR+Ey9jfC8Clp4/bRIrX6DHoBCk3Lr+IkIphK8Tb5ykaSaUuOvwXALFTYB7XVnjKxhwzXG2Pj31XY7Nq7C5KGYtG3K1S5xEbwNTsGJcWHdNWAHo97XxIzUYBhqdSN60rQBuj0YwuLR1DNpyU7v1gj2bN9NZwwqtD1HkXtmb8ap0zU19v1vob6RUYLa/1uCxK2tl2rT8S6vunpbvydmu7LZCSr0Rrrb7aMy//ff4pWihiYRQsk8wt46VlA8S1aXI6ycfzQ/vvqMnxTuGXEmYoqYBA4rfzW/5MoC6lg55o6wK7W3OBWkanHzD4fCK4t9FqWSnnzaSXFvnLI3a6vsWdXyhqDAaxuKKf4Xms51N/dpCmetBDuwnn3o5eSi0FS2STUYFquqvwyIa7WRAnLMapkZCDebZVR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 2:52 AM EST, Chris Down wrote:
> After a KHO kexec, the new kernel keeps the page holding the previous
> kernel's kexec metadata reserved for as long as it runs. It only needs
> the page once, since kho_in_kexec_metadata() copies the previous release
> and the kexec count out of it at boot, and nothing reads it again.
>
> Free it with kho_restore_free() once copying is complete.
>
> Fixes: 76aa46b9e404 ("kho: kexec-metadata: track previous kernel chain")
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  Documentation/admin-guide/mm/kho.rst |  4 +++-
>  kernel/liveupdate/kexec_handover.c   | 10 +++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-g=
uide/mm/kho.rst
> index 902d171a780a..f9d2cc5999ee 100644
> --- a/Documentation/admin-guide/mm/kho.rst
> +++ b/Documentation/admin-guide/mm/kho.rst
> @@ -120,4 +120,6 @@ stabilized.
> =20
>  ``/sys/kernel/debug/kho/in/sub_fdts/``
>      Similar to ``kho/out/sub_fdts/``, but contains sub blobs
> -    of KHO producers passed from the old kernel.
> +    of KHO producers passed from the old kernel. A blob disappears
> +    once the kernel has read and freed it, as ``kexec-metadata`` does
> +    during boot.
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index eeec298aa9d6..3046b89e5db4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1808,6 +1808,9 @@ static void __init kho_in_kexec_metadata(void)
> =20
>  	pr_info("exec from: %s (count %u)\n",
>  		kho_in.previous_release, kho_in.kexec_count);
> +
> +	kho_debugfs_blob_remove(&kho_in.dbg, metadata);
> +	kho_restore_free(metadata);
>  }
> =20
>  /*
> @@ -1885,14 +1888,15 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
> =20
> +	if (fdt)
> +		kho_in_debugfs_init(&kho_in.dbg, fdt);
> +
>  	err =3D kho_kexec_metadata_init(fdt);
>  	if (err)
>  		goto err_free_fdt;
> =20
> -	if (fdt) {
> -		kho_in_debugfs_init(&kho_in.dbg, fdt);
> +	if (fdt)
>  		return 0;
> -	}

This re-ordering can be removed, now that we applied:
https://lore.kernel.org/all/179508700586.361583.12491114908870226409.b4-ty@=
b4/

> =20
>  	for (int i =3D 0; i < kho_bootmem_cnt; i++) {
>  		unsigned long base_pfn =3D PHYS_PFN(kho_bootmem[i].addr);





--=20
Pasha


