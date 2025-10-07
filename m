Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2993ACCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 21:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BF08E0007; Tue,  7 Oct 2025 17:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CC58E0002; Tue,  7 Oct 2025 17:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB2C8E0007; Tue,  7 Oct 2025 17:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6188E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:48:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCC85119A29
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:48:01 +0000 (UTC)
X-FDA: 83972656362.12.CFC166A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id A75C1C0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:47:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FjYePfVx;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759873679; a=rsa-sha256;
	cv=none;
	b=ie+obXa6WtROaAFcvD+GRS7BuvwYfKUm6AJx4KqE4MwhN3SNRVOjf0aAXBX+2lY+pxHqNw
	5MfJdloRHQ3DByVfGNomk67DPRVzc0cekbHVU6nHKolsjptp8NOuxLqtzfarR2LAWYk9sa
	UWGo8PrAw+AXPS88DgyhqYId6SwCBZE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FjYePfVx;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759873679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieAeKXE7WD+v9PCgJseY+hLwiQr0GAdIfqXkALMuGmE=;
	b=Bw3N/cf2KUQ6gn90NM1hAC4CpK3nBT9sCIHq+gTWN1zgZmvSrKvY8ZDemNXbB0Mrmf4dHo
	dNSk8l1CgdwAuCLYk8DUa2I1Ijeu9lxvjF6qUojQ/utoQ4jEiCjX5mGWG/ok9bJanXg5tf
	cDup0fucKHJXpFa9sFAV9rDWqzb92I8=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63994113841so5256323a12.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 14:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759873678; x=1760478478; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ieAeKXE7WD+v9PCgJseY+hLwiQr0GAdIfqXkALMuGmE=;
        b=FjYePfVxTZgcwY7rxni/e1cEoOAHIPLXPJ5+Oz8hCFozhq1oF0Xk7Pipn3E5yLOVNk
         HQs4NS6cTedS+EjATpAYIonSXj5cDeroEtdpzhILHrkGp3w0QxPEUyvy1cqR1IoCZLdV
         TFPmT1mgwnWPqeAU7gtY3Xh+vNrftEbpUVj5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759873678; x=1760478478;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ieAeKXE7WD+v9PCgJseY+hLwiQr0GAdIfqXkALMuGmE=;
        b=w8Sd0Q8vLiqbIYuEXjX4yXCvvQvfAuIgPWk2CMDsxK6ra0/bukqtIwCGfJ1CvkFTOo
         AKR1NWfb9//ingUh5iLlgRzURZSJjlnohNntdnfGAAPaO9V/pKjLCmHZ0iRyjffPJdZF
         kgXIyp+A03blJwOK0YqTOiwJBS5nVLWCKIBCH2D9C/lU7BcAkwothnH+tZ/K8HVlhuf6
         w4lupiEcgn7FxqypOdLx1hwnG4oDfMNU1pXyNzZSh9jbPG0YW8BjOvuUBwEOsVz5qPyp
         rD3tC9fzTxDXmy5I2fCXC0YRhPvcrBg0oLVapv8gwZwyjlVl0GBE50aNdLduGwHJR50m
         tn5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFAbszRA9E+gteGEbG5gWhpH6BlrjbUtq8J71k093onzRDT5egFjDbE4HPPCOXEUWtzg2xBTJyDg==@kvack.org
X-Gm-Message-State: AOJu0Ywfziwxd4+Un1RO8Bu91cG2O2LjbzEG4ue2LeuDwbV2eFtJWWG6
	rGp9q9b6rNYq+GXI+RiwXmTRYR6FQE9gJ+jRdewGwkfAJPEsvN82I/5354Unddnil/+zsVMVC+L
	OI01HLFY=
X-Gm-Gg: ASbGncv2qjU4cON7JJgKklZXIqn1pAkPUT152QsAcgttNTXKtliRj7cDDe7I5OkCFzn
	bPBssN2SunZV4DXoNVKnbMureUV5L/vTYKmCappPhgZRdZQuaji47YCIVawqLP3hBJ0ejAb18w1
	OtkkjAfOD8z8d5Sd/tjsa1MNSOYMFJ87ihvhN5Yg3trmMSUYK9nzpPfqO683uwbrT2thoYeEp4v
	z1ZCQdtV07XD7VSG0LpocUIq2rBAvTJUEk2PlUpgtcEfiGUom2B43Hq+gS+UuUsG6lHEtjvLOpd
	s72D/IBef2QO/HAVMJuL6H75pCir7/k/gK/MAWxIUa2NBbFIphDU8rK3k7UhwVLCtjMmjjfWy1Q
	/Mk2KRIKI5No1uECRFc30GKdBPm1slLVFR1L02h9Z0vi+JE0VJ+tu8J/covWd9gw731oLzCJIuX
	JYxa2nCI+oAcIgJplKKHml
X-Google-Smtp-Source: AGHT+IEpuEZV3ogBqx6OQd+byGiuyZUnrBjUWOMbbIR6uqjMsZriKJineSToB4r/Bomzr3okLI1N1Q==
X-Received: by 2002:a05:6402:2696:b0:639:d9e7:8051 with SMTP id 4fb4d7f45d1cf-639d9e782d5mr295981a12.10.1759873677626;
        Tue, 07 Oct 2025 14:47:57 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63788100129sm13329341a12.24.2025.10.07.14.47.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 14:47:56 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fb48315ddso11847835a12.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 14:47:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWt9bD9ul9XOePICf9vCeJ38oNf4rme0FbjHBk+jUe2UjylgbDxfA5jfaWNBVmzyt9gFFb35Y2wdg==@kvack.org
X-Received: by 2002:a05:6402:50c7:b0:62f:5424:7371 with SMTP id
 4fb4d7f45d1cf-639d5b417e9mr911951a12.8.1759873673957; Tue, 07 Oct 2025
 14:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com> <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
In-Reply-To: <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Oct 2025 14:47:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
X-Gm-Features: AS18NWBCU1N7GZs0SuQExAE_SCw5ZvyC_Nu0gByF0GlCjHapw4qeC1V1VKnS80o
Message-ID: <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000307b730640988582"
X-Rspam-User: 
X-Stat-Signature: n8t5k4b9hqcbg5bagq3ihkbinoprfgy7
X-Rspamd-Queue-Id: A75C1C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1759873679-37294
X-HE-Meta: U2FsdGVkX191yorlcD+m5btLhHJNg+9Bbt3niy9R2I5vohJPQ1hCI+snxXIxn+4+7GBdWIvhCWfwqB6j0OaQkURRdKBwhNslNBMXj2f+gLy9E/mAueKOCw0mx6mOnnBdyqe1bDScIDprpSDjyIH2kgGNfhPEtYur6j+EXZQ0NVGrAR6o+972ig14Dn+oNmT5E4qtZD9bzNf0Yn8aVEhmGkM1/0xaDN+dcnawHrfU11hJ9PPUwB6LMa62DlGyacBCNddxzJPqdO6Udxi+EENcumBaaXBXp7XoCyD7rfkiYB06ihAK/0FtAXKH4ZPv5u/cWEs6+1Vk9dK4qIPwpv2xmcNbsNyM6Cld8med9WNjOUqFzf5OX2JaGuwbfMecWZJNKSZd9moPhoEZOY0Es+2pI3R43jCsRp/VOZWRLewXkr+cd2AzOAPylPbcWf9Vdqnf0WsX29Iax2ExvmbZWe2/mA7H3pCSwy0WKuUqGDA/rIyVFam4R7mys/JMcrvaelKQLrVz0TfVrni1e8AeO6s0byTRPDnz1rKKm9BzTci+m3DLkzjqZI1FcKwLB2wqEO35IsWKHEOvuymDk5j8DiPpMcdn41WsIORjeDH1HqlqMWocu4GabVo0OtAIUQfcbIZodqC7qC4wuGlGU8BuwqjVooDzPLeZx1K90y6kfJEPSR36j2tnlCThZ4GTC7zFMGodXV96NhAzoS1iqarBSemVC6MJvQd7+L6oj/p4CW0YzUGMwCaNtyMCsgtO80jn5EL/voYZuoPisCM7JzB78kfed5KMvQ5Wah/Ls5CXkli93KhrI5Wkn9u76V0i8plBuSwaCuz+jH9nfU1ku8GKhC6wcm8BsF5/6CA9V4l05CKbQ0oaCIat4CMLtqnNVTZd14FLGkcxRAjkXNuh+sqQy/oLwT1PkNUQBH5JQyZTiB/Nyc3T+wg8Agkm86Zal4wmlx+LhVZWG4Q9wCp94OPMMOx
 LiA95I4T
 qvC08qWKWbok/ZQMIWXLSOSz+j/Y5XySxzes4uJ61vv6uL4IKACaZLgUj5QX1nZ3YS3L5jjzQRhgJ++FAlEXj98/NvcVHyXk0NwmMBSS6PIPTRACYam/zPwcOLdqgbeC4P/w8pgQXq+S5hGQeeHJaCVFrydC5BW6hWZHeXBymgSpBnoobgvTXF1HsGiYZ/mRTiSRHRPDBgZkJds92o7OYGPfwN6+WMbUeiJO5JCi7uxF5bak8ecqGSP5IFtVW3VUK9cPdc3dCZWBuiCYUJo8viMz8CIAWnpHTkgeBWOVbgvBfbHnOnvgtls5AUdx38MOBSwMzsySxlCs2OkXXae5dLKzIVv52cQtVHkM4j5oRQfXyOdbdbun0t2liX8LjIpJt+/t2glMTHwnZ0ChrKiHlmjbyjLbxPlOwjRtC9AHoGBt/5GjGZHLggb2aj+iNuoDKNSFQP4+ki+i+mJYdu14iK7D9/dnx51OerCZxRn9olG5MA59LpWNT8DpBuirZzP4z3lHaiOppD+r1OGGnaakVpvCfq2D7EyWovMa3k8PlHmOTJml1VgxKiHHumU3KE2zDo4diJKg1qYT8UlP5sHUne+Z/Ptm8yJp262UWNbpWL722y48bkzW1OAyw7My8cr39Nf4GS2wlCna5W6tcKjY5QFJG6HrDKDAJGudOXurYJHVcU2MLBf2ar2GcgiTTc9DXK/caEn8ZOkPSEHFOXHgx74U/Xab6zdmUcFI6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000307b730640988582
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Oct 2025 at 11:04, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> On Mon, Oct 06, 2025 at 08:50:55AM -0700, Linus Torvalds wrote:
> > On Mon, 6 Oct 2025 at 04:45, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > >
> > >  - Size of area is 256 bytes. I wounder if we want to get the fast read
> > >    to work on full page chunks. Can we dedicate a page per CPU for this?
> > >    I expect it to cover substantially more cases.
> >
> > I guess a percpu page would be good, but I really liked using the
> > buffer we already ended up having for that page array.
> >
> > Maybe worth playing around with.
>
> With page size buffer we might consider serving larger reads in the same
> manner with loop around filemap_fast_read().

Actually, thinking much more about this, I definitely do *not* think
that doing a separate page buffer is a good idea. I think it will only
cause the "fast path" to pollute more of the L1 cache, and slow things
down.

The on-stack buffer, in contrast, will pretty much either already be
in the cache, or would be brought into it regardless. So there's no
extra cache footprint from using it.

But the "loop around filemap_fast_read()" might be a fine idea even
with "just" the 256 byte buffer.

Something ENTIRELY UNTESTED like this, perhaps? This is relative to your patch.

Note: this also ends up doing it all with pagefaults disabled, becasue
that way we can do the looping without dropping and re-taking the RCU
lock. I'm not sure that is sensible, but whatever. Considering that I
didn't test this AT ALL, please just consider this a "wild handwaving"
patch.

           Linus

--000000000000307b730640988582
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mgh3c31f0>
X-Attachment-Id: f_mgh3c31f0

IG1tL2ZpbGVtYXAuYyB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvbW0vZmlsZW1hcC5jIGIvbW0vZmlsZW1hcC5jCmluZGV4IDYwYTdiOTI3NTc0MS4uNTQx
MjczMzg4NTEyIDEwMDY0NAotLS0gYS9tbS9maWxlbWFwLmMKKysrIGIvbW0vZmlsZW1hcC5jCkBA
IC0yNjk3LDcgKzI2OTcsNyBAQCBzdGF0aWMgdm9pZCBmaWxlbWFwX2VuZF9kcm9wYmVoaW5kX3Jl
YWQoc3RydWN0IGZvbGlvICpmb2xpbykKIAl9CiB9CiAKLXN0YXRpYyBpbmxpbmUgdW5zaWduZWQg
bG9uZyBmaWxlbWFwX2Zhc3RfcmVhZChzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKK3N0
YXRpYyB1bnNpZ25lZCBsb25nIGZpbGVtYXBfZmFzdF9yZWFkKHN0cnVjdCBhZGRyZXNzX3NwYWNl
ICptYXBwaW5nLAogCQkJCQkgICAgICBsb2ZmX3QgcG9zLCBjaGFyICpidWZmZXIsCiAJCQkJCSAg
ICAgIHNpemVfdCBzaXplKQogewpAQCAtMjc5MiwyMCArMjc5MiwzOCBAQCBzc2l6ZV90IGZpbGVt
YXBfcmVhZChzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwKIAkgKiBh
bnkgY29tcGlsZXIgaW5pdGlhbGl6YXRpb24gd291bGQgYmUgcG9pbnRsZXNzIHNpbmNlIHRoaXMK
IAkgKiBjYW4gZmlsbCBpdCB3aWxsIGdhcmJhZ2UuCiAJICovCi0JaWYgKGlvdl9pdGVyX2NvdW50
KGl0ZXIpIDw9IHNpemVvZihhcmVhKSkgeworCWlmIChpb3ZfaXRlcl9jb3VudChpdGVyKSA8PSBQ
QUdFX1NJWkUpIHsKIAkJc2l6ZV90IGNvdW50ID0gaW92X2l0ZXJfY291bnQoaXRlcik7CisJCXNp
emVfdCBmYXN0X3JlYWQgPSAwOwogCiAJCS8qIExldCdzIHNlZSBpZiB3ZSBjYW4ganVzdCBkbyB0
aGUgcmVhZCB1bmRlciBSQ1UgKi8KIAkJcmN1X3JlYWRfbG9jaygpOwotCQljb3VudCA9IGZpbGVt
YXBfZmFzdF9yZWFkKG1hcHBpbmcsIGlvY2ItPmtpX3BvcywgYXJlYS5idWZmZXIsIGNvdW50KTsK
KwkJcGFnZWZhdWx0X2Rpc2FibGUoKTsKKwkJZG8geworCQkJc2l6ZV90IGNvcGllZCA9IG1pbihj
b3VudCwgc2l6ZW9mKGFyZWEpKTsKKworCQkJY29waWVkID0gZmlsZW1hcF9mYXN0X3JlYWQobWFw
cGluZywgaW9jYi0+a2lfcG9zLCBhcmVhLmJ1ZmZlciwgY29waWVkKTsKKwkJCWlmICghY29waWVk
KQorCQkJCWJyZWFrOworCQkJY29waWVkID0gY29weV90b19pdGVyKGFyZWEuYnVmZmVyLCBjb3Bp
ZWQsIGl0ZXIpOworCQkJaWYgKCFjb3BpZWQpCisJCQkJYnJlYWs7CisJCQlmYXN0X3JlYWQgKz0g
Y29waWVkOworCQkJaW9jYi0+a2lfcG9zICs9IGNvcGllZDsKKwkJCWFscmVhZHlfcmVhZCArPSBj
b3BpZWQ7CisJCQljb3VudCAtPSBjb3BpZWQ7CisJCX0gd2hpbGUgKGNvdW50KTsKKwkJcGFnZWZh
dWx0X2VuYWJsZSgpOwogCQlyY3VfcmVhZF91bmxvY2soKTsKLQkJaWYgKGNvdW50KSB7Ci0JCQlz
aXplX3QgY29waWVkID0gY29weV90b19pdGVyKGFyZWEuYnVmZmVyLCBjb3VudCwgaXRlcik7Ci0J
CQlpZiAodW5saWtlbHkoIWNvcGllZCkpCi0JCQkJcmV0dXJuIGFscmVhZHlfcmVhZCA/IGFscmVh
ZHlfcmVhZCA6IC1FRkFVTFQ7Ci0JCQlyYS0+cHJldl9wb3MgPSBpb2NiLT5raV9wb3MgKz0gY29w
aWVkOworCisJCWlmIChmYXN0X3JlYWQpIHsKKwkJCXJhLT5wcmV2X3BvcyArPSBmYXN0X3JlYWQ7
CisJCQlhbHJlYWR5X3JlYWQgKz0gZmFzdF9yZWFkOwogCQkJZmlsZV9hY2Nlc3NlZChmaWxwKTsK
LQkJCXJldHVybiBjb3BpZWQgKyBhbHJlYWR5X3JlYWQ7CisKKwkJCS8qIEFsbCBkb25lPyAqLwor
CQkJaWYgKCFjb3VudCkKKwkJCQlyZXR1cm4gYWxyZWFkeV9yZWFkOwogCQl9CiAJfQogCg==
--000000000000307b730640988582--

