Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD08CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7228E0002; Thu,  4 Sep 2025 06:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B982E8E0001; Thu,  4 Sep 2025 06:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD848E0002; Thu,  4 Sep 2025 06:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0728E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:04:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28BAD140A6E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:04:50 +0000 (UTC)
X-FDA: 83851133940.18.A7DF3C9
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4691B14000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:04:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="njQ/2kZa";
	spf=pass (imf09.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756980288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwZNvRadpxpxIRVf3m84OtosJaq4M967tWbwpaNg/Xk=;
	b=g3TEwYangth/FClXD7OcMz6dpeVTHWj+fxxvQhMJ3TzXdMq5JdJSgGmaQMsmQL8z27fgcK
	0dm/wtQB2W4mYT5hcEQQMRa/ST4bjptN8hLRmO+fdC6WqjsT54uQZzyd6VG7HLsOsa6sng
	3HqCIhQJDplcvBBUaD1+VxGjX+BBYtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756980288; a=rsa-sha256;
	cv=none;
	b=y+8M6H3l+douF3QzhH9ZiGX5gryx19fa2X5q0n7BxZgUQRp589WY49kawFapFbEKgF3YRl
	3W/YJCEqym2jOcMBFlxcy7zgqEBFtfbjESsXDLxFinji4V4XGoG1ULwyUKzLEYssprV4mT
	2ZZT94MUBKnjHVU0/1CGHKvLm/rt0tw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="njQ/2kZa";
	spf=pass (imf09.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77247e25a69so111039b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756980287; x=1757585087; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwZNvRadpxpxIRVf3m84OtosJaq4M967tWbwpaNg/Xk=;
        b=njQ/2kZapdUNASJLB25087Zj4bdkC3+WAZ7rHmDlUnDDAyb2zdqLHsmexRj+dDwRMj
         RzuFYH9boa4j2bV4GapCqgun6GM3s/gTKSATAeGGP0RY5fK3RRATWlJ+jNz59+UcAdg0
         X7VAG1Xco3S/KOwV8QdA6P11GCOR1dls0XuAbkVowPN3sP/JIYb8rYBCoeP2/E3QYoH/
         OhjV6lKhdxfqprNI5bJGS31xRnFW8dyOwUbU+0xFIPEvUUnKa0Tl25CaGZIEpM45iVp8
         SV2PXrKfxllHZAoZP3PIEBZx4icNLk9WENgLP08OOj9ahCPCDtawK06XH2TBKlRI3Mi7
         LV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980287; x=1757585087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwZNvRadpxpxIRVf3m84OtosJaq4M967tWbwpaNg/Xk=;
        b=Dd7VNd7ivd0n4wuj31Qj46ym2s6m6H8pnKEA4vGvLiX8UAT4nQ1bIUSSBpcoz1xcjL
         a4cAPZ4DNK+Y4003OH5+66P8smjtHKxdx5294gYB4GZd4BEAeLYJrWKjzamvleysT4cO
         As4dhYDw4hY6r7xTpFVs0SS83ZhrdkhzxVd9MS898P6TN2EhDleQgBgFaZsR9nkIUuWD
         WiYZEcmPCC/zx7CSmF9RqoZfCLjzbOjtg0i0MjgGDQ2cHM8gWPgMIqNEBaq4pZKukINF
         ADxyJyxtsO06CXcUvOxfwwlQp+Qtc0TFpvvzc1v4TDPmOKwCKm1Ou5rgZ9KWb93waqWP
         aGZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxDvZbpvTRRCB3cU6ZU2z6+Hwn5DwA9E+ZvZbp/o2XFGO79zKrSeuIKr3zvWn2OF7JtopwOioF/w==@kvack.org
X-Gm-Message-State: AOJu0YztZAgiClfSPLCbYepzXJ9Kb/Ih2lVtx3QDnO1Q0RSnip8KCC+h
	mA0cvhAkKjxh0eWHhonx4dP1hpEG2OHqmSYk9Flr8149WRvgRSAKgFGMn5X8n9qX
X-Gm-Gg: ASbGnctkNYwR/LwF+z2KhWeVVj/xxwuCwQdWtSgI/4+lzTJxwG/28kQIOdDd/AxG9Lz
	EbG5eCF8vGkdqIMtiaTAF0wUDo/5q6lfqIQP4zsNp6BxtOqvebxUSwblCGGnyf+EJNI1iKqCoPL
	YVFn1xcA5PktZMjhnwhKnHxNWXnPM4gohLsWHMXzxnu49RZtpycvKd9WX6etiIN8LFOXJ7cEypJ
	o00UYC6eJYrL4BPX2gJTZQX6KHU0ZGsX6IIoAA+kM9eejb79lFdw9kLDB/LoBhTX3UiZRveR+fH
	ZLxqt4Y1KOhc6heFZdhwl4vBKQb94pcexPZyIgcyAf+PaAvnQKLcIhc2KNqBBSpBaQIiY/X0W6i
	wsCbD7fUIKGUoAGcudpERvZosDbFtBBE=
X-Google-Smtp-Source: AGHT+IF+X1SXhSvLsR2STae5B7BzOvXd3uYUXi34g9hAOLpClEHMDf7lkVlOfzMYCE6WICcwBjc7Ww==
X-Received: by 2002:a05:6a20:244c:b0:240:a2fb:f8b4 with SMTP id adf61e73a8af0-243c832443fmr17655871637.1.1756980286943;
        Thu, 04 Sep 2025 03:04:46 -0700 (PDT)
Received: from hobbes ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd28ad188sm16564555a12.26.2025.09.04.03.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 03:04:45 -0700 (PDT)
Date: Thu, 4 Sep 2025 00:04:40 -1000
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] fork: simplify overcomplicated if conditions
Message-ID: <ka3dhrfkc42ydbiiqa4ygr545ndydcpekjco36sdwf2nypuy33@vpsgevacmzjv>
References: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
 <tzjq757k4tt7k2mkcapttjuax6zgzr3nl7ivusuvxfmok5kvb4@vub2gw7vp7vu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ymzzeawwxc2g3zor"
Content-Disposition: inline
In-Reply-To: <tzjq757k4tt7k2mkcapttjuax6zgzr3nl7ivusuvxfmok5kvb4@vub2gw7vp7vu>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4691B14000F
X-Stat-Signature: xpnk8778zaf1685dk6brutxyu3uiwzcs
X-HE-Tag: 1756980288-682683
X-HE-Meta: U2FsdGVkX18IceFnE4He5NGK15i2A7d5T1jECuiUvQ44y4asYEuj53my0sbSBhLyCHLJKqXTnTSdQDB0gTNzuldrxrxVCH1RxwQr40TJUzgG77RDjcCc9gdKzE4Q6Ncx9SLhmzlYZ7zFQFHxWZ7KD4TBF0Rh58Mi3eXeTzFcruRIaHKQjc2nuEyr3HYG2au6OswOpEKoLFDBt4K6Nvs9tQbRde2k3rI4oym7zBqAdrhzM/P92mhsoi5LlKXq8VVV1bZSMpDTPd5wQ5/0gCzLIwj626+ocx4GHJMlWkU+nYIN57VRY9lDdCFqxzes6AeXPJqkzgmvVr03rOHeB71VHzTTAhKguSQIiuL0unlISZtUGnXTVyl4Uk28X35EKITfL/HK7bj9g3Eyq9AtnBD56k+tt+JRMmOzioRGHZwhQEpXbKi4gz6sQvrUXuoRWwZC8oXWzqVkocfKa4PZiMjousgJ5oDoLa56dnRqD5+iIhjzZ0PhK+2zdhfFC7u6k4ZSGdDviMT0lIz+aszSCxkZ3zjOgNmBMpzqxK8hHW6dxL+LThkZuBpzzGVwcZAMCh6jfbjJGRdB8T+DzP13Ukl1VSZBEodyRrnySlcY1PQkSJokucfRUAP/xCRlJEpfyV2MIyZkmZApHwV6xnS29vq9sj7cF+rFIwMyZ7XxfBaS4grqEEDSsdLE7HtZlZZqX5HCqFJvsy/AEtHgaMg7vx2PGZJx/pXVrs0sDrZ2NfXSPh+AM9GGGZQZ9lPT1JcNg/4tmRsmXb0UWiWTG8NBk+I31cs2uzZxBu85DVb5EPg68sxYPgBqTbojN5/aYEjx8rN5x8Wiic7dFn+jXcSROja0eic4m0fAvRMsIGID7gDlkccz3X5EsvdmfCCl9OyDyKDVsITLbP4zAihKAQItsYGyJagiU7YDW7Uc6s11OkIhmvMGaGO426M/7ODeScgf96ztd00Iddys1tWt4+v5VpT
 UBBW5bH2
 A0JEfA9FJCNAIj5xiOx69YtCWjihDrsFRQ2Ap75i5+VGzpXYAVXfSsANH8VgJijpOySGq1tm72Gaxmv5dwrk6/SUfX8ulsk9FyRmBdZGt3y5n2oO4NAGE/WcgNNAlmdPdTMzteUqqt55JA5sGfGvl7+hcljWHrT0VKnSv/H8lkfKQUuXGHDBGl4tYdcsF1k0ymWqtpiCA24+mngeqTL+AX7SSdUzrATmE3HwU5QTtJ/5npXlTreNyHz2edsPD8y5oqdpD/lRUR4bTA2idFnVFJpIBHqqXknh3BmNSq+gq/wVP4TLxh6pm8LiQ1NpQeipI82EnH6rhEsHw1vDC2Koy9+MxBb6uWDidWdtqxzUckdm3P0q+bSdClPr68h0jNGXoyWTFBDf987H50coA3ID27qBi7GONc9vBoygzKTZvKbOJovoZYFrTn4L9uM3Ofv/MDBICkQ0iEiA/EeQPbeSt5ynG3hz6GObT1Cv4/hRU4FsHhuc5mi79Dely1F5O0MOHjl+rVPKqeo58WKrLMTEsQaGj6Yv9S+r84GXyKywIVEi6K+rw0TtCIXo3vvCOZPeIBMMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000100, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ymzzeawwxc2g3zor
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] fork: simplify overcomplicated if conditions
MIME-Version: 1.0

On Thu, Sep 04, 2025 at 10:56:44AM +0100, Kiryl Shutsemau wrote:
> On Wed, Sep 03, 2025 at 08:46:29PM -1000, Joey Pabalinas wrote:
> > Since `((a & (b|c)) =3D=3D (b|c))` is the same thing as `(a & (b|c))`, =
use
> > the second version which is simpler.
>=20
> Huh? No it is not the same thing.
>=20
> a =3D 1;
> b =3D 1;
> c =3D 2;
>=20
> (a & (b|c)) is 1 which is true.
> ((a & (b|c)) =3D=3D (b|c)) is false.

Ah, you are right. My mistake.

--=20
Cheers,
Joey Pabalinas

--ymzzeawwxc2g3zor
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEx6b1SGGPTKxTmPDYqoHu9CTxowIFAmi5ZDgACgkQqoHu9CTx
owLh+w//U4ZIZrFjLogDei6exnHDOuFwna9rLLOTeaNNuCkYQ/bYafNjDKPxGRiG
8G8+8Zp5E8ikB+OjsL9Hv5QlOEcSd/d/iDg0Gz7WP5QqWj40zn9i4RD1mKyOPRvk
n856U0I63VRyihPXU9HfxD10hEkK4HY+B+6u68qt3MYom7imTqWWNJEEkdeHYhUV
U/80q7aLhADIPwdI+dimNX5vy2GPZ0NDhPnuBgHev6dyhSBypbaGTY5Obluwa4qJ
b8aTS9mD5gj1ig2W3P4LJWZQcarTxgC0Qgqtndwil5gta8Fsdwm6xhpMa6WKwXda
F8YeUzc1QzWFp4OFsOcGHdLikesUGFQvkq1Dyolq3HIvkZWYJoRsXi0Y3hynvldc
GKG64E1mbHd7u6l8pHTGPjgstUyji3IuUGLrz17hST5lO7SXKcq4SuEtquA/2Fnu
QHtlXmD3g9Jp42A6k9FRBjpdTV06KxMZK+aFpSOgaa2pgOJYJB5XkjvlByBlWWez
M6ujDIyXC4DryasgAAUhDK4w9wd9VporBa6dlWqmxVRE1QJgmOjqlEVjstQK2Psq
IbUQt1UZaJ3KoQulTcQjKJVUjCstQ3sL6M92iSvt2dqvJ1US6TB8t5QQthrh+wGn
k1abKf4f+8MxDnzmgKBkF5psz+dFfjlI8QWXBWEInRsYBBIJSEk=
=zIT4
-----END PGP SIGNATURE-----

--ymzzeawwxc2g3zor--

