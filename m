Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194C7F53D78
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4435A6B02F2; Mon, 16 Mar 2026 13:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAC76B0326; Mon, 16 Mar 2026 13:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCA66B0327; Mon, 16 Mar 2026 13:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6B16B02F2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC91E1A0223
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:09:39 +0000 (UTC)
X-FDA: 84552562878.28.D4AB1E4
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id A48EE1C0008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:09:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=atHJG5po;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773680977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+JmK53GRb51WN1NqYAYXjEI124SxFiHPFttdlfjYpg=;
	b=GTX3apth029F+aeptsiGgtOVMyPsCYVuYYlyIpklQgOZKzDc7TfzDOl944lYJ7jh3s5xbJ
	idJn/Xqu9povFqp89tzFbcQEkZuRN9oHsWX6JmsM1oFoHKqtt/lVFF5VACHBSePdLEjV5/
	9CJPJtr18hwgJAQE8Eqx7afocMur+mE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=atHJG5po;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773680977; a=rsa-sha256;
	cv=pass;
	b=HArofRogN+CfmLZdVT80cHVLOT8lHUVK1kvfgk4kp6DaopVkWNHJQ8gxXetCkuHmzE63cR
	9xwtXV74tr3XoX11h9TotV8e0+ScH8d6OQPJJDAdrMXFJzph42anj9sGm6ZmEp8p1leTcR
	okeS3vAfpTN0MYeGENE+UuSo14g3O6I=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a133b686f7so4348776e87.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773680976; cv=none;
        d=google.com; s=arc-20240605;
        b=KPXgg9hcwVkZT6YN8Nl6EKNB/B9qybW5U9UUStNsC2bd2V3KLJIc8AZ2eQzcrL8vb3
         FIZhiwPrJ17t+eYWlyadYWUi9pTczByHHLTBILw3G9uJ2MJB9x6d033h+iuIv6W3ws+f
         0u4iOmUjXa9GPg+wD9tY9n1dRQBipuOs0T/4rjgvVE5ja++o+hfr/1w127N0OboDSIJx
         RDnOZlsy5xtw3O9uFu9KCHJnAJWHAi1w8OZNMvDDImL2E4N+YItf4r3Et2e8P6GYBAop
         N8YZZ4K3Kv7Vr30TZsYwpkPHbYyf+aJktPMQuYEr+33jbmFn8ok2fvhMHU1xUrSADqdB
         kvFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9+JmK53GRb51WN1NqYAYXjEI124SxFiHPFttdlfjYpg=;
        fh=kveJ4XMBZwOsUmJEsgkA3t3HyWqB0JS5cp2n7qyhOqs=;
        b=QHGAhlsJJJ9D5A/oxEStU4KTCfnyod4J8rJDz6B5cY0x73twAwMBTz7DTeYxQbhJy8
         LkyS0xjMbvjPFJb0ZU0ydouW3PNWHF1sI3RTxlGowOQT+0Z2ASDqwEogbKRmMoasuFAS
         J3ZeAjFZIXb9uakUjNtod0FUUZPsg01gTDxRqKhA68tPkhtai5SniZS5/rD9zEh3uF02
         68N+e1jWyp79vJyXCg3HCH028KjyDqZn3tTF2ZPlW3miub9hfjXhhrTtFA5t1pFvZEWA
         o/CU+8VyrW7AhAbBFvYf62nJlnCizxpRB7ZIPdEp0it5idcapr2KVKMbtPwt5UlF4+cJ
         Ds/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773680976; x=1774285776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+JmK53GRb51WN1NqYAYXjEI124SxFiHPFttdlfjYpg=;
        b=atHJG5povP6CZZqJ3qF+/H/kPZTwr/J/K+MMh3ILxQzsm/onKWbMmaboMHMZOzYNns
         Ipy8x0P0UMk6yC+INHNl7OswFm05rBz8muv0pFMzubDJiPkvpZPPW6hLJFvh6/ffM+Ev
         cinf9GQI+IN/Uqxi1Etqc/mfBkJN6NWLKGbk62pVZyJFvUWmCFwNK619NyqtueaRkZ8a
         018olGAVwYz0fqWkfM8YlcPcMe+zlY7tLYf2wArs0dSBbWyG5lCA4R41pef6382/2Mb0
         S/BlP8tNbQAcp9dBNx81PfWfL89qc5xOihtRN3zmXvWHpjaOp4w6FI0slRvioGQPxvPF
         xhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773680976; x=1774285776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9+JmK53GRb51WN1NqYAYXjEI124SxFiHPFttdlfjYpg=;
        b=QxKYGAl+XWtU/lkTnAAGKXKh1TeB29jekSMUmO+GYF/M4ekdtthpYALh1zKYKsD2Ve
         ldM5tfQg6Z8q9++ekonjFk5zK6jqjsqMRC+lJCO+W2DzM47NxdLq34N7fSF6qMy0KPZe
         QGtpBUd/GZTfN3I7w//Dw5v48XS1E7OXhA6gtlV6dw9LB55m90L5J7ujyrRrh6PjJ7lE
         FhFIkSO29hMvdilLQ2HxIvX/NunzaPxGytbqwO3R1dznrjyF0hmVn8cIgBRL/MCHB6Tr
         fdZ741H+U33wGIojEKCnJBm/b9UiVyyOVmCRMHq/CN8uzHVreZWY+b8S5eNeP6OUsG2C
         h3Nw==
X-Forwarded-Encrypted: i=1; AJvYcCU0vcvfOFnzsFbvB90Vi39bZbT0PudowbFuxEJUiJ/v5kjhAAAOtxHBif4VN9CgBI8i97ltpKqGrQ==@kvack.org
X-Gm-Message-State: AOJu0Yyrh+rg3lIk/Q/cyqrbW/RIO3/tZcHibegX/8jqWB7u7wLyZ8/f
	Z4mTkrE2x4S5MkB3gZdWmtsuLJqVwkJbV/otRgChRHsBOGEk5dbAiYAfwQ/jueHkMHRJZKGqlCq
	h9JTcpVUWDzpZzUVctgi2HoEGZAJNwEQrjmePZrqm
X-Gm-Gg: ATEYQzzmCPvKDCUhcH3Ogdh/VtfWjgh+h3rnwihgp6w+vEmMYrjcJVvZGhal5soW3Zs
	GLJOTWsUBn03O9cqZihWg+w1g4ELvtAPpfoWKcsycv//nLM2sdOFkt9FtiE3LXGKuLzQjOjAvxI
	Ca2asW2OHsVECtxUSsE6/MDZ5fdecKV7UCmvHDKzz/iIfWSleFtKNmkIg1b3IkhRNS+2vyqnBQ6
	EMCMzXHhQuy1cfq9zXXefKxKZ7+jnIm2U/KI0nfTYZ4Tf/lSXlTNwQ0fdkFxyJod3Byy4dsZp3d
	KDNlKMQD
X-Received: by 2002:a05:6512:64e2:b0:59f:6a2e:49e4 with SMTP id
 2adb3069b0e04-5a1626fb8abmr3594350e87.7.1773680975067; Mon, 16 Mar 2026
 10:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-8-dmatlack@google.com>
 <20260314061747.GD4177610.vipinsh@google.com>
In-Reply-To: <20260314061747.GD4177610.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 10:09:07 -0700
X-Gm-Features: AaiRm52NY6sLPHJr9Fl_13O_4mOB8Cua734qhyhURDdG8FlJ-PNRJ5f7ttW8G5g
Message-ID: <CALzav=cQQny8AXzewtSe2pM-Z20+K9UbTcNBiy6SC4PUzR3sng@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
To: Vipin Sharma <vipinsh@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A48EE1C0008
X-Stat-Signature: 1o7xwmnt7gkuptrdkyzq59713btytawb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773680977-664667
X-HE-Meta: U2FsdGVkX1/GrWt3lVQUzkrnkAhDsVhd4k4V5ZcUOGa9H8/Owmdid9eYUQ3wk+yTmpZyl250sjiFsNvvOVYL0UUCXmYphOPFCOL5ugxRlE5KLexl3kMGm0oZc3Owm0KD6PO4ZKnKwodx6FVT/P+lBIYiunrfNdab/LGwtGSD2ccXcQzEzvGAj4yngieNFYZGJKGUZGH0sawVwDv9LEydTKgfUwBuc0z2gEgvvbghod/4VeHETi/jLlbviINbnjDUEykEbME7avAbtXZTVEfNj8+vHVHCoW9V/9nb7Vu7Dj0wWM0JxuwKw5IJ8c1tajNo3dDWVaXwVjo2YcFXjArRdxsPCzuF6lVLvcKoWuAtwxKIdN9a9GrrHOXhE83zToQ6vjHB/D0PkxCpgnVbYgdd88kMlbnH29On+NdWxC7gPvgBTaMWH+2Vmg26TpsekDt6EeKWmpdgIFNegbsqI2tD1NyxNxDbjtrSDPHIBijfYVJoM3s9m9izb8ArsHxax+04VojnFVKu3ZdbXMwGQE/4eBKK1kfpouyVhlbXSR9+xQTA7h1cvquM5drHshAlvToA83UDDlYzOb7wNLqhTKS8iYIv3s5LQ9qYM6Zsp1tUdmqItZvfELpvH26auFja1kq6dca/g3X+JNlJGruHVjemVK+6MQ02eq8qs/akwMzoB57/odbhuv5soaYZPhJ9Z/Zf37OB/zjp6z7pDcc0AcwchjxsL0Djvnk/ZOZvDOxsrQmdmPxuqmDUL0e6WU7BQQAN/UwuofGZpvvWOT5rsp2IzX1Tn1tMRxlQYmbfyzwMnG5tfDWaRmyLI7PzRRgG0jzyrXWM4y5JDOpJqNS/oPqTbstYezCyXj+ZIdl54RWJZI4B8nTW1XyZwJqIc6OGRfMW32buZ/t6blnJs4YKDm1eZLlyUWU/NWT+B5Ww5uSVtlcfRKMgPo0XCTTWcV4h/nu+8NQhpf474KUXVPuuXYQ
 YU3Dz1b9
 EMZHcNaFxlVex7wK/DY3+DsJF/Fb9jVLaXjnt7a+O8A1lR38ZolHfqUtwa0GcY3r0rtOMVBmT/ODZVPRvmAl+sB8HOB4C1WBX70WeN2hxVmSfvXqnJQSrEWE/aXV92+CnPid/MyAWPN+osJtSx5xTlodkMrpnR3oMK7cYPvC2HFRCoDIe6OPAtGouXvx9WWXCFwLw1FwroN9Aqynb5KT/nuAVeb59t3KHf2Q8DnzgsT+SomhefvrPHqtcAVuFyHIT+1L/6569VFEUykUAsnyKiehioieBw19OR5GG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 9:03=E2=80=AFAM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/=
vfio_pci_liveupdate.c
> > @@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_li=
veupdate_fh =3D {
> >
> >  int __init vfio_pci_liveupdate_init(void)
> >  {
> > +     int ret;
> > +
> >       if (!liveupdate_enabled())
> >               return 0;
> >
> > -     return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +     ret =3D liveupdate_register_file_handler(&vfio_pci_liveupdate_fh)=
;
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
>
> May be we should rename pci_liveupdate_register_fh() to something like
> pci_register_to_liveupdate_flb(). In the current way, it is confusing to
> why same handler is getting registered at two places.
>
> Above name will also make it similar to IOMMU series as well
>   https://lore.kernel.org/kvm/20260203220948.2176157-2-skhawaja@google.co=
m/

Will do.

