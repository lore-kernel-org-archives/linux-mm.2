Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A32F54ADA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDCD6B0088; Tue, 24 Mar 2026 12:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657836B0089; Tue, 24 Mar 2026 12:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8256B008A; Tue, 24 Mar 2026 12:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3969B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E441E1401C0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:46:38 +0000 (UTC)
X-FDA: 84581535276.27.15CD38F
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 577EB80010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:46:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bKlI14jX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774370795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCikAyXiicm5k2VXyH9xrW1vWINN0uWZrBsYrIEp9jQ=;
	b=xk6F+nZqT3VI89loTDXY82555o/slnskrmIEOrT/zGzihi8FoCM6GCzRLbACGCH+s86MZc
	zJUGbKQsOHbR4rs2ORS73KiAjtEW+hfapxTgvAOsxStgjHCpCRiKdgaPJQdrKFtSoP9Axi
	rcvtvM5RibdJ6wOTfQlM3G1REGL2ZEI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774370795; a=rsa-sha256;
	cv=pass;
	b=ZbSpugQzl6fKTtdvPx2RRRQGM7lAExjZdh/+u3xeks0g07LbmhyEASYqAqcUZYepEAM0kJ
	uK0pNkgyhrrs4EBFBo5mDXxr5d/yrKrd/HkNbSgImCZoGM2dm4A4Rg1+lI4fu94MQIJqqM
	ggwMU/sS1IapwK2fNHGhFsriPJNnWwI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bKlI14jX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38a2e62b893so11442481fa.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774370793; cv=none;
        d=google.com; s=arc-20240605;
        b=DJxoncggGIff44t4LL1g/68hWsml8pi8/oOCZPLfFwDajGpUSOBh52oYjeawKNh0dw
         zyHYWf8un4sKJ8YSmYZTGo0gaOYKtgJRECDwjIL7CMyh1HTSlzujxzz8uo03O6p5epFX
         fQ9wqH52YAho+jqMRUH87iU7RgiwmZNlqtawJC6f+A+Iw22OSuKsaa2qBnU4eiiHabNo
         PwP4GN2uOIFHnD64kxUAG3zgSy25YzizaxPkTOliVQ28KGCsRCAtUB0tTXyWmfQ3fqjx
         1Js5YdaK94mgyUYD36eyugP0xO0RyyPzPFv6C/CT5Jc/Kn/KUYdvPgN8iu+2wBp1PWvI
         bb7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UCikAyXiicm5k2VXyH9xrW1vWINN0uWZrBsYrIEp9jQ=;
        fh=hgqTbkhTNNXqwxeGERGPhaZ9aXCZuSUMCB4ftnKfrG0=;
        b=j1dZtc0CoWdNtCDnqIX83MpPVKCcAqZnXGqUoaBLqBa5UK5WHOhxpTU//7nTg8i7VC
         2knJRIXHEaYVaOKZYfbuZqOw7dSwM0VX8hbU70qBAcCYXpGyV6cUcg04Jha5j6dfYfDg
         sQYuLeBenznjS4t3Ij4Uihc+kBIHv7g2Tk/PRVO/3xG/DJ1LSp627hOCP8zIGm/BH+7x
         vxA8FTOWBuXgsyJ4/xvVGDxfUOxH72EqloyMue7AwQk82k/mthM93sVd48qdhC+Swzs3
         9gc03moD0cgNT7dKCQZf1/stOxsP39DhtQRtID1Zp7mCwWZYRoMBQVS+Py5d6yd8DF9d
         bdQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774370793; x=1774975593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UCikAyXiicm5k2VXyH9xrW1vWINN0uWZrBsYrIEp9jQ=;
        b=bKlI14jXbjYZ/p5s9KKBen/kd17AJJJL3xTISLXug2xGLoEkP25l36pZ4zXmRg0Xlo
         uccuf7CMLP/SrjjU8q2Mt9aTAhZ/7BwqR3/P4zKfgMs4rygSHb5/L2kLGLu0+X53TtXF
         JMi2W4Q+2DSDgHPOeEbin27d+4UqoaCQjhhGx66OJ8lUv6tTCy5JbtpTygjEUnIkG+a2
         3cqBDLWUUGpzGJQ3BDvSnFS1uyCOAVso1ZV96qoHPRT0JFzEWwhjHtGw7pPck29tIxPA
         og/YevIuKv5yLnllj1aM1XvbEkTDNl7jWKiWjY2yuyDuEsuBwoZKFmJDILbdsx6EiKm1
         rj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774370793; x=1774975593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UCikAyXiicm5k2VXyH9xrW1vWINN0uWZrBsYrIEp9jQ=;
        b=nElGWl5Q6Ey798VNIZaGOQXlzqtSPPWtxv/W6z+hvN4UYTfRBLOuOzUyP4N2WQMfC2
         nTOBs57cltdg/uw4t6hHdXCe/bkT8lEwdFj69gFUUkus8DRr2tZyZqEC3Umkurlh4wTf
         PnxdYABdslBvuZBtzS4Mf9wYS2TfRtHvT3zqPdaAZLK5koGmXXC9fIeSD6r4nNIIMivD
         eM8cNliICULX3DAFnn7exquLPj5q77VLf7zh9nAkByIkgcePKHGWtL3JA1cKGG0wRfzG
         4+ktvbOe+8OLtgH7EJMsGqlprD+MPWCVyP0E3t+vfhPZfxihFsebn0pAg4AKztLSMoq5
         B5hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh/Ty6RbSeTvDfoNEPv4PCjvDqbgVdnUolxCNAvIEPn1v9vB0O1MqkhFOBJEnfl93e19pVJuxBsw==@kvack.org
X-Gm-Message-State: AOJu0Yzzg04mjr/jRRKY9WQIz+ZXzTA5Y9OovgdneLuBRB02uLZKJhJZ
	VaNmWq2BTI3Zrh7rLL5v+sBqN4cj8P4xR5ddhxhJWIWirqHFvRXG4mnuAIM2Lq0ZH6UZR0I+bp0
	9B2jTW7VLJPBai+CI5xUnW//cP3gprAJSeTu08bH0
X-Gm-Gg: ATEYQzy8SQZFj01H1Tz6lprKEAhLjxUyX1EiZRWrTPqghbJGFvz2iePAqGIO+w/StJ2
	BUQcekZXClEqJwcBhdsQeBoDDdPy2Qu4h19bBIGSXkD1KBRxOSycU3KJDkh84X1aa/FX4O8eT/Z
	vw1YTEvStPHtvtV0ee+Yxi+YNUDNreQps3iMx4jdvO+kyxog16snCMAEEafu2HYSf0F0RTa2WTC
	m1vvKAMlJKm/Y3/o+OEphfFDHUFCC0L6as1mWUo7Rr6GZkjFLnjPkUCiIbFyZR8T7E2vjc4d5Ns
	dSDe+NFf
X-Received: by 2002:a05:651c:198d:b0:38a:45d6:c246 with SMTP id
 38308e7fff4ca-38c4309f785mr403821fa.8.1774370792285; Tue, 24 Mar 2026
 09:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-8-dmatlack@google.com>
 <df5dac48-8a54-49e2-acb8-9370b7078033@intel.com>
In-Reply-To: <df5dac48-8a54-49e2-acb8-9370b7078033@intel.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Mar 2026 09:46:03 -0700
X-Gm-Features: AaiRm53x8nRAyhq72BKXQ8vBk2jNU8cpC5QwT_5hu3qjlEbsk36YMzg6v1f1PaQ
Message-ID: <CALzav=cGzzZTL-tyaaG_AhC3gP7ULiU6hWS=X6joLTjyoo-6sg@mail.gmail.com>
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 577EB80010
X-Stat-Signature: fuwwtsd61g77t14oba3an8knmk79k8sy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774370794-144391
X-HE-Meta: U2FsdGVkX18bJptVd9Tvza6hpXMQjgFaIgZ0uXlTIA8A2xvkgQjtqLTuJS8otyuKkMlaHxGTF528wviFZUwfRm5bbhFKRKptmJ0c+FeoXBXGlU34LCgOinWOpo5CyPmrdMixZrKJoeqS6TA0vbQPH2wpmhccGEdhlF6EQTMcJGDfk6H+3XgeZ3ol74n9mWTXqk4Dw3uOXF60ZQtMtbpq8QjibdQOVLCU+bTFjxKIc7+Oc6X/qKBCutChNZknXjGZ0HFxuxe1BuvQQvjtwUoPO5OKrdOsv1dMeWbiKUjz9myYqYUzsTWkHteETOlli4E2nObEV9DkPG8vItBJsfiXnEOxNXdvGp0l/o1ZrXOiAgjXWaUMEltyLLITxoOlIWjGzDku3oy0z3uvCFWx1J+wo6Dvx7ipjbLMLafcvqcVtePvnS7SCWu+XkLQ+QhmSrZudxLal7ljg1BXo5tep+JaJ5urC5UMHrNTq07PjKYyVsPYfoFvxIfwbi/wH7SeH/ySaCj2X/tTbEn6SrSjIvtadDmj06vNsuEpFl5J7HsdQUo/riZN8wFtlSJbxRcswRGoN4DriJaWLTRMUx1DBbfrkk5ZeaBiPjMfEMnvIq9KJuZUaFdLyXgTnzoRj+KtUJBFdU8iCdtAoVysWebEvzpVJOsGTcIHgNwfIFNg1p+31Wl5QDGp8juoZBQS2wTkdQWUZ7KJNxitKp6UqJS6qKY3KojvfSP98K056tlU2UhG62Z5fD8QSWaJ17Keo8ScVhWDZYmlAyfncMP43eZe0GDrLi7Qz83plBU4m06qDlW8Na9aCrUh4j8bk9waXgwZSYyqpla0P7Javgk0Jug3mviogBLsRPgNaXYbZnmAHsL8j3VR+aLz54ux4MfDIAfn/mUvFvpigSTSWzNbaU7P+hQkDWBFobbQpaEQUeS1d5AprD7/m8lyT83EsUtfYCRq6cH0Y6WWYl6IRQHEu8hcxh7
 VscQoUCM
 X04Rki+IE1Ek4+OG1/yPbZi9H5CnhOItIrDFsLPXwvFeGVxv5Ui2ptxZYuRiI9SzNuAkzxvEfbXQmh5nAwXjh2DDvkVnr4qw8vigu4gQkHu3v2kOTh+BogJ1t8gETMRido6lYX2hveoG8nX84YCgbl/0Kx8hdMyx+mlCn+RhCcrvAU6p0Gjw8j8JxPYCAnh5inG4neIGOnqGMkA5vF8hLrk1qX1CBqaWDTtYR4EuOKwr7c3Rqg3eqrI5NH/ShSXknLsav8etnaKKjhe/X2t6voSgsEScn7eYO8EuipbnsWwOzdk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 6:01=E2=80=AFAM Yi Liu <yi.l.liu@intel.com> wrote:
> On 3/24/26 07:57, David Matlack wrote:

> > + * Usage Example
> > + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > + *
> > + * VFIO PCI devices can be preserved across a kexec by preserving the =
file
> > + * associated with the device in a LUO session::
> > + *
> > + *   device_fd =3D open("/dev/vfio/devices/X");
>
> /dev/vfio/devices/vfioX

Will fix in v4.

> > + *  * The device file must have been acquired from the VFIO character =
device,
> > + *    not ``VFIO_GROUP_GET_DEVICE_FD``.
>
> how about "The device file descriptor must be obtained by opening the
> VFIO device
> character device (``/dev/vfio/devices/vfioX``), not via
> ``VFIO_GROUP_GET_DEVICE_FD``."?
>
> just be aligned with the below words in vfio.rst.
>
> "Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
> user can now acquire a device fd by directly opening a character device
> /dev/vfio/devices/vfioX"

Thanks for the suggestion. Here is the wording I have for v4:

  *  * The device file being preserved must have been obtained by
opening the
  *    VFIO character device (``/dev/vfio/devices/vfioX``), not via
  *    ``VFIO_GROUP_GET_DEVICE_FD``.

> > +#include <linux/kexec_handover.h>
> >   #include <linux/kho/abi/vfio_pci.h>
> >   #include <linux/liveupdate.h>
> >   #include <linux/errno.h>
> > +#include <linux/vfio.h>
>
> maybe follow alphabet order. errno.h would be moved to the top first.

I will reorder errno.h to be at the top in the previous patch (where
the alphabetical ordering issue is introduced).

