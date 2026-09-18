Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B087DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DBB6B0096; Fri, 18 Sep 2026 06:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE376B0098; Fri, 18 Sep 2026 06:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2A26B0099; Fri, 18 Sep 2026 06:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1196B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:27:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D38B21405DD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:27:47 +0000 (UTC)
X-FDA: 85226506974.28.2070CD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 429A11C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:27:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=ItzDXld2;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkLUZeEnA99up/AmsUqwvacnHC/Y0Zt1xYo4A0fMueU=;
	b=mCuDy0MUL9Jf/7YuCIunLr9TSRytOgl5jNnwndnbOhLrooTDDX12SscVtW+tQ4XczULvF3
	VPdQTtH40OejsJL4CI3+U+RZ+3VcewQqN3jhOJ0AjjiYY2cppbnABYJ4pe7S4VUxZBx6EA
	WYMHCccZVxjrQGTPmuzTn7j5oSGhNt8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=ItzDXld2;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727266;
	b=r2EP1mcppoHG4Mz8ZQDwjD15Dp59/zvj8YdUoZvE8Nwkb+ZN6ZRlagO6zNGIE6NZjSf82H
	mjW6rEObwgWuspQmPuFfwL02wou31OJ0bAlcc+lWLdQJ97zM8T6Bo9jRVG4lWeeEDPPqnx
	tqmm75+yv9Kzi6ndto0D4j3IOaA9ykA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7F5D60A5E;
	Fri, 18 Sep 2026 10:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414E21F000FF;
	Fri, 18 Sep 2026 10:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727265;
	bh=lkLUZeEnA99up/AmsUqwvacnHC/Y0Zt1xYo4A0fMueU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ItzDXld2tby73VnalPfFMVQddC2s2ymzPgOS0ZChmR6dOPmegwuawzKjHFqmMDoF+
	 PoZnRzNeer2r2DmBsq/eYo8kJQkp1OBiPfBHHigVnCjlgxEslJ0v7OyJRVXzipoRBv
	 VZm1TT9Lc9oR99b5nG8pRlbO28sXT4TMcnVHOAs0mtzpIFRCVsuwztBBK5NyDHXE69
	 g15J3QHHDpWuZan+MCFxgFzN0l+Ef/JrBCLZq6PLqNVSm+GrT5waIr6oFwxfqDKTF7
	 ocTlp0emFiq+z7MtcqR5prTkmyE5VRJTzdZXh6UAWU9dGt07xnJ/Qg428kUKc3T4oP
	 n9iVhqtdLNzqg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/17] crash: Normalize the kexec_load elfcorehdr at
 load time
Reply-To: sashiko-reviews@lists.linux.dev
To: baoquan.he@linux.dev, gregkh@linuxfoundation.org,
	ruirui.yang@linux.dev, npiggin@gmail.com, liukexin@kylinos.cn,
	dave.hansen@linux.intel.com, mclapinski@google.com,
	ritesh.list@gmail.com, takahiro.akashi@linaro.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, will@kernel.org, pratyush@kernel.org,
	coxu@redhat.com, mingo@redhat.com, zhangtianyang@loongson.cn,
	linux-fsdevel@vger.kernel.org, sourabhjain@linux.ibm.com,
	hpa@zytor.com, rafael@kernel.org, graf@amazon.com,
	ruanjinjie@huawei.com, jbouron@amazon.com, yeoreum.yun@arm.com,
	hbathini@linux.ibm.com, chenhuacai@kernel.org,
	akpm@linux-foundation.org, lizhengyu3@huawei.com, chleroy@kernel.org,
	adityag@linux.ibm.com, dakr@kernel.org, piliu@redhat.com,
	pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, ardb@kernel.org, leitao@debian.org,
	catalin.marinas@arm.com, kees@kernel.org, thuth@redhat.com,
	blum@kernel.org, kas@kernel.org, maddy@linux.ibm.com,
	james.morse@arm.com, tglx@kernel.org, bp@alien8.d, e@kvack.org,
	mark.rutland@arm.com, driver-core@lists.linux.dev, kernel@xen0n.name,
	chao.gao@intel.com, eric.devolder@oracle.com, tangyouling@kylinos.cn,
	palmer@rivosinc.com, loongarch@lists.linux.dev, bgwin@google.com,
	guodongtai@kylinos.cn, rppt@kernel.org,
	linuxppc-dev@lists.ozlabs.org, maqianga@uniontech.com,
	seanjc@google.com, vishal.l.verma@intel.com, robh@kernel.org,
	gshan@redhat.com, "Jinjie  Ruan" <ruanjinjie@huawei.com>,
	me@linux.beauty, sshegde@linux.ibm.com, mpe@ellerman.id.au
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-12-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-12-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:27:41 +0000
Message-Id: <20260918102742.414E21F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 429A11C0002
X-Stat-Signature: w35supzjbanchsa1rqam3goyzrh6z3ii
X-Rspam-User: 
X-HE-Tag: 1789727266-672648
X-HE-Meta: U2FsdGVkX181ZazaRYlUgAhH9JTFo31aM9EjBzNKnC7cBlIsOY7mL8h0OVloGnpZrno2j26ISkN7TeGZEphMsT6xA29snhEg9KzkzgPL01x4OuGIbtrOJnVP6vmroF99iWZeyRNjDwG3WK7hg20dRlbdMGga4hFVsIp/HKMPkcU7PWb2llARfJNykDoIvr0aCa0n6uGCCZhE5cNBjRjfPY8c6DJjVoPmG83ZmOYijEyYAbg7tvOc10E26ZPwLy8ZjJLUayFEWy65Ds+jYymmAQD+zv/uNA/evrgWKaFDee20925xmm6bNrWEeucNU5lwdxHtBAmD15XikdqUubTa99zUqee04FMRTCopkZPZqgi66vZ9uuHVelnqeChvOJE8f5XFWlohvVog7RH5LKsN/iccyIr0ifvtTKzDLANd2bCkpu1H/WYYNKuROYcE7L/Xh1pWc0pxyvhBU73cpbcLnCkDtYMIR+LOWN7GwGDkzlQUc4skWplD0ZBlP8BDt0qhXhgwA3PRNRxcqaf4tDevHz8/O62EQSNi2ZwllebuTLxh6AAOt+kcZaysN1rn8qFkGIKDXgddOACtiFgNfrbS9TKfaAXSXbzYAC16yQngu+6CXRnCxhNHHxQr/8Zc0Os71tEp/Dt+598IR1DaYi3eW8uWvqjK2td/zgcDBxrcMurF/0tyAKdSohtdZAfYEJl9F/L8WUJ0OxoLzqcfnBaeO/6r87nKGTP6XM2SvRHvgmX4HVKUbGXQzsXkYG8gyHfJA4lOirjIqNFRLID4FW6ThlfJuX7a4x4PGG2FV7cJE1ejC2Zxsze84QQ383qSXpgttXRRxDYayAHJdLNU253ZGBXs+qtOj94WBr3u3vJB/8n18mQWP3yOor8Mu3genPEpWpdI0viwlZXnVKSLv/P0fbMUvNRlEYCzgUehmurr/vz4iZ3NTkvDJqyVJa0qtspTnCq3T/a5KR6iw593yfF
 r3gDm8A1
 sQsjQd7Nb//TlMiK+R/V0WkYHpo206qSQnm1HBLL+jVT14eXdBtihmTRMbCQ+Ogyx7YYajK7HTINu4ER3DUo9NTZasdbFKQ+RAdYfixAab19pypgvRDTtvo/a4615y4JXIdW7TsfSHuGdJ/b2PA+/0HOGiTpADUrQ1/hu0ULftEhhr5aRS1vN+RgKdHZqoEJ41k2gJCywVN8K8XWkoUvZB7UGsqcTVPcKUSsCde2iKyVkuTFi4tOWMIg2pr6fJJg1ZncVWzTln8lWI9zxHRKI/snFlBDlDw6HltGLNmx3Q6IeatkM+h/91jRcLoRLmq+GxjEhb5nNb30pUVDxGo58npStG2T7Ipc55RoJwyiFN9Bj1xAs7vzhHrHer3c2W1All0iYbzfXZ41V8SEK2lOvNQCBDT6x3pXVThphAvdjwF+JoPSpdOVimmfz99ck0EaqF/HYA1wGQyC6+yoAM1O9bln4kxG5rhEfdRh5om9n06Un/xhHJNfbZLGayGw8nvLNPc+vIQrDhvzDvypjV0JmEVNUZSojZsiz0b8sdNQL0BM6+h6GIMbMOYCGVFYOXw3H89wAl0Oi4a3z863/iuirTsqMopiBxmqzz63NZO6f/JBdYlpbYF5Cyuvo4H4QoBzQZgXblu1IUT3GDORoCio3fHR+QcM0RTP7ZaWiqWJebiTiI9eZysDjvWlmaaU4SzhxaEqvYIotEQD70wIgCXWx2qbjLpJHvlI1C3nBDd6G+dXnNMSbzdEz1vwMLZMLiWZDSzQTNCXE6sQLQFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kexec: elfcorehdr_updated in struct kimage is write-only and unused
--

commit 463b7b7692d8e96dc1be8ffaed1b6d0c8d298c9f
Author: Jinjie Ruan <ruanjinjie@huawei.com>

crash: Normalize the kexec_load elfcorehdr at load time

This commit changes kexec_load to normalize the elfcorehdr at load time
instead of waiting for the first crash hotplug event. By doing this while
the device_hotplug_lock can be safely taken, it allows hotplug paths to
skip CPU events safely and avoid racing with memory hotplug.

> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 3c9f4fbbe7ff0..f34fa8dba0288 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -457,9 +457,8 @@ void arch_crash_handle_hotplug_event(struct kimage *i=
mage, void *arg)
>  	 * possible CPUs, there is no need to update the elfcorehdr
>  	 * for additional CPU changes.
>  	 */
> -	if ((image->file_mode || image->elfcorehdr_updated) &&
> -		((image->hp_action =3D=3D KEXEC_CRASH_HP_ADD_CPU) ||
> -		(image->hp_action =3D=3D KEXEC_CRASH_HP_REMOVE_CPU)))
> +	if (image->hp_action =3D=3D KEXEC_CRASH_HP_ADD_CPU ||
> +	    image->hp_action =3D=3D KEXEC_CRASH_HP_REMOVE_CPU)
>  		return;

[Severity: Low]
Does this leave elfcorehdr_updated as a write-only and unused field?

Since this patch removes the last reader of image->elfcorehdr_updated,
the field is now only written to in crash_handle_hotplug_event() and
initialized in kernel/kexec_core.c:

kernel/crash_core.c:crash_handle_hotplug_event() {
    ...
    image->hp_action =3D KEXEC_CRASH_HP_NONE;
    image->elfcorehdr_updated =3D true;
    ...
}

Should the elfcorehdr_updated field be completely removed from struct kimage
in include/linux/kexec.h along with its assignments to avoid dead code and
structure overhead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D11

