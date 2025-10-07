Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10FACCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B3C8E000F; Tue,  7 Oct 2025 18:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B1F8E0005; Tue,  7 Oct 2025 18:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A608E000F; Tue,  7 Oct 2025 18:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2EA8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:54:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 926B51A02BC
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:54:43 +0000 (UTC)
X-FDA: 83972824446.29.65A5B27
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97DF414000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:54:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="FgIe0S/B";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759877681; a=rsa-sha256;
	cv=none;
	b=HSpetqr1k7M40rIxn155gXFiU8BcB54F57wti++zhUDIHEK6NJQ7ALWw+5rVyE07MOz8gf
	Zu+l3/fjFukegHm30F2UXjAHH6yOYaAUmtf+p+gL8IMtlg3vwXJKfJpUeqiekqXUY5qslW
	5hUj/7EN6syxu0XVhqH60tansF14VQ0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="FgIe0S/B";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759877681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iocGsaFxj9W0yHWPhGI/EVJ1XNtx6l/u9S4RmMWxmZo=;
	b=5hns633/+exb9ghzV4b/kECDDyGW+gEmgZTtCHmcW1Q3VNIA8Maboj34FwlM1Ee61GtmjQ
	l2uNj70YyqV3XlzlvsebuAKtk1agUAvXNgc6depY/gyKYbQQ4oinw81H8M0i7gJ1Q3lD/N
	sB20Xe+0bfVTcmg2tJidHAyco66YYPw=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-634cef434beso482477a12.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759877680; x=1760482480; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iocGsaFxj9W0yHWPhGI/EVJ1XNtx6l/u9S4RmMWxmZo=;
        b=FgIe0S/BRA/vNQQEqhqGn2eCsX600ALm5YkyFh+I0I3kJ275KAb5GFybuXObDWLuN0
         EHi15A0nrD1Y+xgsu9NcAwgCPkLcHJBtUaCW376IN9b/N8Be7B5sLiT7fdXLUcf7ghqE
         c+Up3WAYSwXh5O4UU82P1gKYBWzTJYLN492eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759877680; x=1760482480;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iocGsaFxj9W0yHWPhGI/EVJ1XNtx6l/u9S4RmMWxmZo=;
        b=JbH7KcfeHq2YxzNaXbYCTMpUqnwAq0JTbmTS5N1u034yTS1SJ3H2MtZzIniLqk0qzz
         C96/Uk7C9MZGNyN09HL0QYTcyiRz0DRiMm+feQ/9UokC5PEcfJ6t5iYUHBZJpAbCTQLQ
         HXfwVoBK3c8D++slVuqaN6j8l1tOvy+RWiuk6zHJJcf30gce+X0ANWLpqB1+JLMyywBO
         HT+c8JbhfGBrfNyhe/Je8JEBzRdz4Sju7IUFXFbEBkwUSqz3vYnGC17g6aFDelqSs8OQ
         m/mZcbb9mPVXyW74oyffErzISUwM2FtKPDKbQlwZHI9LVunL0WEjDWfGdgK1e4BQQfwC
         1uWA==
X-Forwarded-Encrypted: i=1; AJvYcCUAHiuzsaoPhkqp/L7UpvtgN/4DyWoYTluC0ziCw+Dlhiumc4I0F6Vz7cVC73PihpH473IW2impeQ==@kvack.org
X-Gm-Message-State: AOJu0YysGXgdSmNhP62CYzvZAV+Uajk0Y2OF9DL62ksu//avG4Aj2jca
	e7hfk1GwvzCb7DfEDZZhVNTJA4eACNtp4U4TNC5S6GDTnJ++EGFyIARhhWPh+XxvXmBBSugP2BC
	SZspekas=
X-Gm-Gg: ASbGncsUyhD3vZ5qoYG+7mTuXN31s+0g6z3nYdOBOasqII++lR71RWoFDIMjOCRH/Wi
	/1XDY2VDxV5KYQGjA1BVbSfXNw1POFznDCkh8b6MT2iFqHDCS4Em64OBhmXdXkAdSljWlcEfLtB
	/sJXOksr5ccnhcnTPaNGUgZ6ENroO5gRExTB1cUGgFP+gY40q9ohB+l0XbB+VwfR7CbK2nv3t5L
	6K+0WOt8XG7cuiNQnUdUp9xKZ/5BMq+5zBuqGmAqAIAqETJnMS32FAdtLVezC6DMSUdOjVSh0DV
	DBzdmHKS+zCegrdtA4OqMr7EJ1k3cKfeJlLvX/NzXWbM2zJv02+kTng6sCohORC2KSyGBeOfTLa
	VsdiE+eIGgM8ED2yIFo1rAequvSxvp3ZAd6PZkNZnmo8M/KFnixCWat5EiCwMs4owk2fAQtZuRO
	Rv8Sz7VfihnUhGSTR5KTmi
X-Google-Smtp-Source: AGHT+IH2nXlVlSQ5C82PwDhQWwnhhTA1hLq36fBcYsekGDNcWbY3vku4XOVGsYEWGxrIR/DGLykKeQ==
X-Received: by 2002:a17:907:a710:b0:b27:edf1:f638 with SMTP id a640c23a62f3a-b4f43106a07mr525363566b.23.1759877679634;
        Tue, 07 Oct 2025 15:54:39 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-639d4a67888sm736974a12.1.2025.10.07.15.54.37
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 15:54:39 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b00a9989633so81196166b.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:54:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUOZQkk3QAf+duc4TnpsVRwfFrmlWyRR5K+2vkpmHaUuPd/BWcBMHMibj48seeuutkFXT70jBWDJg==@kvack.org
X-Received: by 2002:a17:907:a70d:b0:b4a:e7fa:3196 with SMTP id
 a640c23a62f3a-b4f429efe15mr563250766b.20.1759877677521; Tue, 07 Oct 2025
 15:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com> <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
In-Reply-To: <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Oct 2025 15:54:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
X-Gm-Features: AS18NWCjiZmGz9lB5bT-2RpXXU6lsyJbiuU0NDcMLPnF_ouVHC3HSZomRtmlOeE
Message-ID: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d19e860640997327"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 97DF414000E
X-Stat-Signature: ay3yecz6rnoh771fjigoyeakdxcm5aww
X-HE-Tag: 1759877681-349935
X-HE-Meta: U2FsdGVkX1/izrMRKNeyogcE0BvIvrZ1IafB/7jZ4V7musi5PinSgXJDZn3kzAGNaLtx4WobAua/zKYB7TUkaxPXHWfHZU02XB5vkm2IPb2r5kUSGyGkWc9GW6XP+HBZFZuNcsS5cRehq6tfTozZqZlqBMgOCwKzRO037tMGktGXlQnNCbYHN2fQ3MUS0wqHiVr/WGi/AejsUSmW+Q64LjKyGguABri0Esl598KtE5YfvX1nNPIUeJgnxQ1CcS9vad+BlUflCJ4U1QFPy/2ZpkxzsE6U0YqABPk25uZCD7xAr7soy7AdPMiebwZz2EWHWrB6CqhNZkDpmRexUCm7xsqhKqU/14cctK06Z348m0Zhg+SoTBNw8jSCHL/K4hL+WvIdrNx5DRsLYCwVFDpRD88oJLPXVWmUcJhl/CPZz8f+7bn9PLX/5zyQZF4wNI//Boi4KWHTfaU+PjtfmRvTernpfUk0OcGRBgozvs6rHCVTnyu7+VpAPzKIq0YcTKcIeYEGrz3WwqgIWgl14UzSuJbWR/7Z4gDr1lkzB1YshVklpPIcQ8Qdz7qA5gM60pIxawjhk7x8OYIZ6HyI54eMc/04C5KD9iFF0BsCA97htwGsfUw8f2xLPwOO/ma+B3mV9oDWWAR6cIvdVIUbmPqAX+gWyTNq+v6f9oSOXgIYq4nHd4LowSnZ8jtSC0cApuwErNbNDI4wmbZ6zaMCYP3VxoW4vHuV/WEXSr0mp0s2ZxVxkBJpMlXtSS+LidiSMIRvHjhmoTQFgOOKa2fyybRMMKL6uQT05vAzpkSbp6qzQ+L9YyO8lygitvBijiMhoyb8l7RxV5Vb5tO6i4ZXvxe38pX4ajvYPYCYq+FuD5hpslwqgzrw7X/f4GkLJ6tLRaC6ifUwk/w8jiqdtYCLmvfoTkb+ij0E03uF5MppLSrg72D0vn54eWC2MdunmVdMJ8slYXAgghVJqYVbmpsEJ6+
 evOy4Foi
 bXJbMfcGWkg91EeDV6PgkHRsN1vpHM1XJaQFzkMWe9xWDuRU7r6IQh+llwyTB4jvzlVcHvjhzmO2bHUYFY0ZHQQJBqk0QlCo0iiOGZ0b633T9KwSLJWTzSEh1p6lX7lxppME85XvOjL+zUgnwwrqlnIMsqHe/VbIEKW7LTvmclnolWTJh7wYzusZGaU3ectA8O/S/pZhjVngIToJp5ucG1CNRCfNr1G6wHXjffRLnmDfR0sD4NuX+6YTX+2JUPrC5Dukx/7gWDE9A3eBOrbUQMlRq8ms2h5wr2dsTAK5xudg0pxms/4RKS0Yd5VwChWc1gSmTqu6okHxN2ZjI965aC7k/DILkL6G5d1h9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000d19e860640997327
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Oct 2025 at 15:35, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But I think I'll try to boot it next. Wish me luck.

Bah. It boots - after you fix the stupid double increment of 'already_copied'.

I didn't remove the update inside the loop when I made it update it
after the loop.

So here's the slightly fixed patch that actually does boot - and that
I'm running right now. But I wouldn't call it exactly "tested".

Caveat patchor.

          Linus

--000000000000d19e860640997327
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mgh5pv7k0>
X-Attachment-Id: f_mgh5pv7k0

CiBtbS9maWxlbWFwLmMgfCAzMyArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRleCA2MGE3YjkyNzU3NDEuLmJhMTFm
MDE4Y2E2YiAxMDA2NDQKLS0tIGEvbW0vZmlsZW1hcC5jCisrKyBiL21tL2ZpbGVtYXAuYwpAQCAt
Mjc5MiwyMCArMjc5MiwzNyBAQCBzc2l6ZV90IGZpbGVtYXBfcmVhZChzdHJ1Y3Qga2lvY2IgKmlv
Y2IsIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwKIAkgKiBhbnkgY29tcGlsZXIgaW5pdGlhbGl6YXRp
b24gd291bGQgYmUgcG9pbnRsZXNzIHNpbmNlIHRoaXMKIAkgKiBjYW4gZmlsbCBpdCB3aWxsIGdh
cmJhZ2UuCiAJICovCi0JaWYgKGlvdl9pdGVyX2NvdW50KGl0ZXIpIDw9IHNpemVvZihhcmVhKSkg
eworCWlmIChpb3ZfaXRlcl9jb3VudChpdGVyKSA8PSBQQUdFX1NJWkUpIHsKIAkJc2l6ZV90IGNv
dW50ID0gaW92X2l0ZXJfY291bnQoaXRlcik7CisJCXNpemVfdCBmYXN0X3JlYWQgPSAwOwogCiAJ
CS8qIExldCdzIHNlZSBpZiB3ZSBjYW4ganVzdCBkbyB0aGUgcmVhZCB1bmRlciBSQ1UgKi8KIAkJ
cmN1X3JlYWRfbG9jaygpOwotCQljb3VudCA9IGZpbGVtYXBfZmFzdF9yZWFkKG1hcHBpbmcsIGlv
Y2ItPmtpX3BvcywgYXJlYS5idWZmZXIsIGNvdW50KTsKKwkJcGFnZWZhdWx0X2Rpc2FibGUoKTsK
KwkJZG8geworCQkJc2l6ZV90IGNvcGllZCA9IG1pbihjb3VudCwgc2l6ZW9mKGFyZWEpKTsKKwor
CQkJY29waWVkID0gZmlsZW1hcF9mYXN0X3JlYWQobWFwcGluZywgaW9jYi0+a2lfcG9zLCBhcmVh
LmJ1ZmZlciwgY29waWVkKTsKKwkJCWlmICghY29waWVkKQorCQkJCWJyZWFrOworCQkJY29waWVk
ID0gY29weV90b19pdGVyKGFyZWEuYnVmZmVyLCBjb3BpZWQsIGl0ZXIpOworCQkJaWYgKCFjb3Bp
ZWQpCisJCQkJYnJlYWs7CisJCQlmYXN0X3JlYWQgKz0gY29waWVkOworCQkJaW9jYi0+a2lfcG9z
ICs9IGNvcGllZDsKKwkJCWNvdW50IC09IGNvcGllZDsKKwkJfSB3aGlsZSAoY291bnQpOworCQlw
YWdlZmF1bHRfZW5hYmxlKCk7CiAJCXJjdV9yZWFkX3VubG9jaygpOwotCQlpZiAoY291bnQpIHsK
LQkJCXNpemVfdCBjb3BpZWQgPSBjb3B5X3RvX2l0ZXIoYXJlYS5idWZmZXIsIGNvdW50LCBpdGVy
KTsKLQkJCWlmICh1bmxpa2VseSghY29waWVkKSkKLQkJCQlyZXR1cm4gYWxyZWFkeV9yZWFkID8g
YWxyZWFkeV9yZWFkIDogLUVGQVVMVDsKLQkJCXJhLT5wcmV2X3BvcyA9IGlvY2ItPmtpX3BvcyAr
PSBjb3BpZWQ7CisKKwkJaWYgKGZhc3RfcmVhZCkgeworCQkJcmEtPnByZXZfcG9zICs9IGZhc3Rf
cmVhZDsKKwkJCWFscmVhZHlfcmVhZCArPSBmYXN0X3JlYWQ7CiAJCQlmaWxlX2FjY2Vzc2VkKGZp
bHApOwotCQkJcmV0dXJuIGNvcGllZCArIGFscmVhZHlfcmVhZDsKKworCQkJLyogQWxsIGRvbmU/
ICovCisJCQlpZiAoIWNvdW50KQorCQkJCXJldHVybiBhbHJlYWR5X3JlYWQ7CiAJCX0KIAl9CiAK
--000000000000d19e860640997327--

