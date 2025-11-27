Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B86DCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643156B0088; Thu, 27 Nov 2025 18:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3896B0089; Thu, 27 Nov 2025 18:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3CC6B008A; Thu, 27 Nov 2025 18:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 398F16B0088
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:37:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC2B988B33
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:13 +0000 (UTC)
X-FDA: 84158000346.19.ECBD8E2
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com [209.85.166.196])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0ADDB40008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ng9s/ZKX";
	spf=pass (imf12.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.196 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk8iKAKQiPWWx1WeLeJvPjSrW4ytPNU/VipTWSO/YTo=;
	b=e+2YWaeL1Yr2Y89/gHl4dOVzW5HwYApIG5P8Eym5ZL012GDLrls3bdI9rCFBtrXF8fHWaw
	QGZOKWVCTvnHHu1KlTp3Mxjuea5HE4UAjBjXePeOMxmAYrNNKrLZ4C8jaQT9CVaHp6kDPs
	oRMX+okSBXwaxAnGEtHH0YNciJS7RIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286632; a=rsa-sha256;
	cv=none;
	b=wR4beVrDQkFulzO05WF6F7gYv666vkUrLxkBwXgxeu+QZ5Mpmg4b7kGao5FLuspaDpBFR9
	aJ/uBXD32AD0rhR8gocNI3zeQEj8pkX0n+/zDcD9Y2NWvwidf7gS7UEF6OzZIMjeN0PAmi
	kON+oRtHZq0TrC/qe1Y1w/cv40FDzvs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ng9s/ZKX";
	spf=pass (imf12.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.196 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f196.google.com with SMTP id e9e14a558f8ab-4334eb02acfso367155ab.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764286631; x=1764891431; darn=kvack.org;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lk8iKAKQiPWWx1WeLeJvPjSrW4ytPNU/VipTWSO/YTo=;
        b=ng9s/ZKXDdmuKbulvMxbOxIOusGJiRX3aStUlzKU1lG/Y6tTMudeJL8io+YHhGEI1K
         uejkuYtpdaw2uRNi89kmw3Dx8dZocOroSrBhSFp2qpjwA8iYRxFKxgOXJJ7fFn32agsF
         mTfl1NVbRBwIBn37DkKvUXt7NxRXhGYtRdbxt87Ilac15N9L2GNIQC3UKeLIHfhBS7xv
         YrNmxl9PRxvwArhusrvOFqz1yEilOgNnuS23DuNtRc3c87tkPvvu4H/YSF+kmXaU2rIP
         G6GShRgiBOG+hOpPopsieAvLpu9ZQKWYOwd/ePG3oL4fzyH2nsVojyOADKALDQpfmOMn
         vaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764286631; x=1764891431;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lk8iKAKQiPWWx1WeLeJvPjSrW4ytPNU/VipTWSO/YTo=;
        b=QRws8eTLlmGtocOoAT7M1VBAvfWuVpdTve4AKM2vn20iS84xnhGXXenxgPJgLIPWOc
         Z5KFpxkf9O3wHoRN05fewnZalN1kAvXpUCsCYhmdFuJnBf/foG1Ncm0jiQwnJw2Trvhk
         bPJr4x/ULyfley2ZA/+nhRLUhVgGhBuyl/9JJ22eMpAHFkNAkWm3HnikxG+YTA6Jw3YJ
         N12AU9NTIkHo+NDutV01q+ANudctqEVYw7fwSoubYTtZuhY9PwJ59jEwoN6rHJA6VxZg
         6nNsqOU0N6eBCjXiNJv2ou57To67YfA9n5sI5ZBqjxsErSGmrA9TQySy03WhehOoSpwq
         gNDQ==
X-Gm-Message-State: AOJu0YyXbInUO6wfye1RklT7ddYu74Pemuhp2GgTFIBPfzfdv6iipkdW
	78EUmdSka1yssVkquVU8OdrurFZ7VPYa8LOt104rcWBKKKzg6xQWwJEi
X-Gm-Gg: ASbGncuGJk6C5/eUL2L2wxBwJeDsJ7MBJDzVYH15uSKaBfPGkoWzqMCHur/KSwN1iC4
	gHxqxkuIPhvkOJwrYGreldr5bEoNy5Qo0/YGNiABwHpRx2+JIIW1R/F04YZppFLDNSMyxCGcOH6
	QsmSepk0wFKGsr24NthREXphbdVbRRZzE/vKE7cixzxq0xMZMkqpJ3FtEo3esvXHQ64fK0londW
	wcKC62IKcLxgFmzvJYniI6L9hDodx5Jze8leJQT0rE5ihHNzYj0NLUC+n/TrPJ+VbzMlb+h4fqr
	Hczs3G1WICJvZtrHztCi/orduAsFcXRu7/Htf61a0mWZ6eQREgbvTqJPat3YCltrvxzA8wvhhq6
	AB7voGsq/3aDSbN1ssP3LYAJHrHrbqN6dywmsLV7s24DoKH6ypLY6rYZai5dZlpBUKqe1oyjIYi
	pB1MZntEQ=
X-Google-Smtp-Source: AGHT+IGreBlJthqbMD1RAWCcqBxs8A6SNjHp+XNg4XupKhfTAUt2Dl+zj7BYsLX7N0vJY781hdNvXQ==
X-Received: by 2002:a92:c247:0:b0:433:7818:d1c4 with SMTP id e9e14a558f8ab-435b8e474e6mr87255305ab.3.1764286630861;
        Thu, 27 Nov 2025 15:37:10 -0800 (PST)
Received: from kf-m2g5 ([2607:fb90:bf0b:8b65:e4a9:bd5:56d9:5426])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-436b85c5413sm14379825ab.27.2025.11.27.15.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 15:37:10 -0800 (PST)
Date: Thu, 27 Nov 2025 17:37:02 -0600
From: Aaron Rainbolt <arraybolt3@gmail.com>
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-mm@kvack.org, cryptsetup@lists.linux.dev,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 linux-kernel@vger.kernel.org, adrelanos@whonix.org, Mikulas Patocka
 <mpatocka@redhat.com>
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
Message-ID: <20251127173702.6c8a7ba2@kf-m2g5>
In-Reply-To: <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
References: <20251111231835.1232ad8f@kf-m2g5>
	<2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.XCJlYJqF5QI/5Sz1Tc2Qnf";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0ADDB40008
X-Stat-Signature: yjn1d8r1kgimukpky6kqcrkxrefr93jz
X-Rspam-User: 
X-HE-Tag: 1764286631-428764
X-HE-Meta: U2FsdGVkX1/l0eJyIees5+9LgDTUaWSxFzsNrKMHzHmjYmhNt6r/OEyDAwtRqUJc6jQE9ykEmD6PRJ0tGmBkiU5idJtLIPDCMREL9TO4SsQQg4cyNbiDWdfPSkuTZ0fWhamPwf263aliuLVeSoZx+/ccVjjzZxqtAbB51tF2v1BiCgYVsEfgKSfcSLg+6hRk8noo/bL+zJfYcV9ChAAOA9VGeOIZtKemz3Vdi0oIu7Jr4V/Ljr6EvE/kn+annSvtuki/ehj9Dwm/ECU9VnKb9AKOEo8LEtK/RyfC/upyEI0MXcUILx1iVSqt+oJpTsvzutCNjfYEMHCwA0wsVq3LAJb5b5x6AK/IVZbnczgNyZAx1P3BzeQEg8TMPHa/tVjTTo2wyxQLCFnUZpKgb2kgDDcrjHh9U8XHKyyoY8otGxrA/6dvERwXBFwV0paIMNEr/Cu0jWjfo2dWked/vYlBrPDT8AOxb4yvUg0JCNcqWeZVNBcW3XsORIoPE9pjJgm+CwYDWWWf2gJlEQiJOeoWAGbxajEqg8Yhu4ybfifHIBYE6Zq9DxdiUiUM0vqLl1OyuXxYHx2i3oMOuJSQ8ne9lZn0J2vTvOyUD/xuUcz14CG7aEhfc0LPI19fGp9AkN/QfuslwpVeNafozxu+HrSH4TH5I4Px5qvr6CDxc9jCyVyWgVl/SGm88vP2R1EegV6V5bB2brV7jMRAq1MD8DS+CEvcw1HykBsNgyD0DSj5q4sL6j4/Q74YVt0WA+Vco7mzjoH/MtATTQeMCmJlMdZlhdtbGqGjK9Zj02qkpx05cFRYnZIkUTKF4bf9xwhqou/NyatrUh7elmyYqKwoLwK/QsiVcuK0UvonvMQlwlgS8O2xdpeeAmu7kuKSH+/nU/s968ECscryEbA41VE4O4Luj13azGDt4aGphD9FIiIexQL1cOe3oKKXIJoPjRTFPd4wYuy6b841osLAGCBhhkN
 HyHDFwdp
 gFYPNIa7TXpcj/VpOKVGZnBzLTVzJHUGYSK4mTisYoK6dZpBa9GjwyIdI/rTSD9O2Mmah/Cx7zf4zV/CPGnKp/cs6OIc7eAHvelQ8qgJwmaQ6okHyyc7XT89XCvswt2foy1dqOz+d40gC5cbxcCVPvhG7erdjo4+kZ80nzWyFHkgL5hdaxBU2uImCuKSvfIpYklarHms8PM1ISTeRUWYiZom7EapsrwroqJnNDJTwPyaUPbue+TqxoBiHAXPyVaCoJosiWfDbSocKCX8f/PHIyKzxaDAxMcZL61iHEqnto4dI9Xl6s2zli5YKrhQS9Y4t+skF+LXk+a+I1zyfy9URdkps2p/RMFv4HsQvV2QASuCETOnIRgR8LvDNqGWYi+ShUomPd0JhVf7Jrpvs0OB3t+57AyGGZWvAznBAWgEW3X/nVcASqt4TVtAd2ILLllf1OeSIbkUWGQwduy9oU8CuqZGs8Wblx6IkxKNryZNzXnsvrO3UHO0am9v4ZXnSwFWQZEV6sc5qksxeeDWefXyGfBMx2ULMXgoxSNoqMBLSifTwjmxVKu7w+p2pPByfhlAVUycW0L+fGaong5YA0w1uM3Y8jv7Fe6PkFlrb9EKTZo9WS3nlJQsy/y9muYI2m7XNWy3zWlEyufakn3azBdaXynXcqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/.XCJlYJqF5QI/5Sz1Tc2Qnf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 08:59:13 +0100
Milan Broz <gmazyland@gmail.com> wrote:

> Hi,
>=20
> On 11/12/25 6:18 AM, Aaron Rainbolt wrote:
> > Not sure if this is a memory management issue, a LUKS issue, or
> > both, so I wrote both mailing lists. =20
>=20
> It is not a LUKS issue; cryptsetup/LUKS activates the encrypted
> device, so it is only the kernel/dm-crypt handling IOs.
>=20
> Adding cc to dm-devel as this would be another combination
> device-mapper and encrypted swap that could cause issues...
>=20
> However, could you please specify exactly your storage configuration?
>=20
>  From the subject, I expected you to have an encrypted swap, but it is
> not clear if there are other encrypted devices.
>
> Please paste at least lsblk, lsblk -f output, and also luksDump
> (or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.

Mikulas seems to have reproduced the issue already, but just in case
it's still useful, here's the requested data, along with /etc/fstab.
(/dev/sda2 is a BIOS boot partition.)

-----

[sysmaint ~]% lsblk   =20
NAME   MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
loop0    7:0    0    4G  0 loop =20
=E2=94=94=E2=94=80swap 254:0    0    4G  0 crypt [SWAP]
sda      8:0    0  100G  0 disk =20
=E2=94=9C=E2=94=80sda1   8:1    0  100M  0 part  /boot/efi
=E2=94=9C=E2=94=80sda2   8:2    0    1M  0 part =20
=E2=94=94=E2=94=80sda3   8:3    0 99.9G  0 part  /

-----

[sysmaint ~]% lsblk -f
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUS=
E% MOUNTPOINTS
loop0  swap   1           0a06fb5a-39f5-4a89-b8a8-fdc2470ee0f3   =20
=E2=94=94=E2=94=80swap swap   1     swap  f9aa44bb-2214-4a32-ac7e-34360b0f3=
13b                [SWAP]
sda   =20
=E2=94=9C=E2=94=80sda1 vfat   FAT32 EFI   6907-5000                        =
                   /boot/efi
=E2=94=9C=E2=94=80sda2   =20
=E2=94=94=E2=94=80sda3 ext4   1.0         26ada0c0-1165-4098-884d-aafd2220c=
2c6   64.7G    29% /

-----

[sysmaint ~]% cat /etc/crypttab   =20
# <target name> <source device>         <key file>      <options>
swap /swapfile /dev/urandom swap,noearly

-----

[sysmaint ~]% cat /etc/fstab   =20
# /etc/fstab - created by grml-debootstrap on Sun Nov  2 20:23:37 UTC 2025
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/disk/by-uuid/26ada0c0-1165-4098-884d-aafd2220c2c6 /  auto    defaults,=
errors=3Dremount-ro,x-systemd.growfs 0   1  =20
UUID=3D6907-5000  /boot/efi       vfat    umask=3D0077      0       1  =20
proc           /proc        proc    defaults                      0   0  =20
/dev/cdrom     /mnt/cdrom0  iso9660 ro,user,noauto                0   0  =20
# some other examples:
# /dev/sda2       none         swap    sw,pri=3D0             0   0  =20
# /dev/hda1       /Grml        ext3    dev,suid,user,noauto 0  2
# //1.2.3.4/pub   /smb/pub     cifs    user,noauto,uid=3Dgrml,gid=3Dgrml 0 =
0=20
# linux:/pub      /beer        nfs     defaults             0  0
# tmpfs           /tmp         tmpfs   size=3D300M            0  0
# /dev/sda5       none         swap    sw                   0  0
/dev/mapper/swap none swap sw 0 0

--
Aaron

> Thanks,
> Milan
>=20
>=20
> >=20
> > I'm seeing an issue with both the latest mainline kernel (6.18-rc5)
> > and Debian 13's 6.12 kernel package. When physical memory fills up,
> > the entire system locks up hard, as if it hit rather severe
> > thrashing, despite the fact that there appears to be disk cache
> > that can still be evicted, and there is ample amounts of swap space
> > remaining (gigabytes of it). This issue did not occur with the 6.1
> > kernel in Debian 12. I'm seeing this occur in very low-memory
> > Debian VMs, with between 512 and 900 MB RAM, running under
> > VirtualBox and KVM. (I suspect, but have not verified, that I'm
> > seeing similar behavior under Xen as well.) These VMs generally use
> > a swappiness of 1, though I have seen a lockup occur even with a
> > swappiness of 60. The filesystem in use, in case it matters, is
> > ext4.
> >=20
> > To reproduce on a system running Linux 6.18-rc5, with :
> >=20
> > * Follow the steps from
> >    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQues=
tions,
> >    section "2.3 How do I set up encrypted swap?", but creating a
> >    swapfile rather than a swap partition. I created an 8 GB swapfile
> >    with fallocate. Reboot the system when done.
> > * In a TTY, open a terminal multiplexer (or something you can abuse
> > as one, Vim works well), and open two terminals. In one terminal,
> > run `htop` so you can observe memory and swap usage.
> > * In the `htop` terminal, sort by M_RESIDENT.
> > * In the other terminal, create a new file `test.py`, that will
> >    gradually fill memory at a relatively fast pace and print an
> >    indicator that it's still alive. I used the following code for
> > this:
> >=20
> >      import time
> >=20
> >      count =3D 0
> >      mem_list =3D []
> >      while True:
> >          mem_list.append([x for x in range(2048)])
> >          count +=3D 1
> >          time.sleep(0.002)
> >          print(count)
> >=20
> > * Run the script with `python3 test.py`.
> > * While the script runs, observe the growing memory usage in `htop`.
> >    Swap usage should start at or near 0, RAM usage will gradually
> >    increase. Once RAM usage starts getting high, some data will
> > start being swapped out as expected, but after a short while the
> > whole VM will lock up despite there being gigabytes of swap left.
> > (On my KVM VM, the last time htop updated its screen, it showed RAM
> > usage of 712M/846M, and swap usage of 328M/7.40G. The python3
> > process running the script was consuming 551M memory. The VM is
> > entirely unresponsive. Incidentally, the python3 process also was in
> >    uninterruptible sleep when htop last updated its screen, but that
> >    could mean nothing since it might have come out of sleep between
> > the last screen update and the VM lockup.)
> >=20
> > Under Bookworm with Linux 6.1, the Python script would occasionally
> > freeze, but the VM would remain responsive, and the script would
> > eventually resume. Even with kernel 6.12, both unencrypted
> > swapfiles and swapfiles that are technically unencrypted but live
> > on a LUKS volume both behave as expected. It's only swapfiles that
> > are themselves encrypted that seem to trigger these lockups.
> >=20
> > I haven't looked at the code at all, but it seems like maybe memory
> > LUKS needs available in order to operate is being consumed, thus
> > making it impossible to swap anything in and out of the swapfile?
> > That seems like it would cause these symptoms or similar, though I
> > don't know.
> >=20
> > Let me know if I can provide any further information on the issue.
> > I'm happy to bisect the kernel if it will help.
> >=20
> > --
> > Aaron =20
>=20


--Sig_/.XCJlYJqF5QI/5Sz1Tc2Qnf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEudh48PFXwyPDa0wGpwkWDXPHkQkFAmko4J4ACgkQpwkWDXPH
kQmMIhAAvF1ssmiCQ+nw1++89u8VMQnbSRCywdjHphhTMKbxhnnwEsNiH55N1w6b
5ssVxIvA2KrJ5+Ac3KVNr7h4o7t3hb5nEQL/MXWpfMISdyaBZR5n6GlG2Y/AIhJA
dzv3yEyCSXCYvH+TIhe8l+eBzrEUeVJg7vh88Tmm7XwMawBuhPx4UxA25POEzh07
rLwCy+o1AagTJJ7Ugvj+Ok9Oj5uZ8dMo68wWWDJuiLX5LXZ1Cvy2YGguco66xB6D
YaHKTVrsKAo6C57vXVfoiISXepgHD9+2SVd8jJdA5O0SFc907ITPMCqD68QQcdWi
jr2V1CKktd0HnzjuY2+IlOp1qVALUHmxhqULO6eNKaBDhSejwEamGeuWmBzUfv2f
STm6PTrWBjI93laXCkWW1cCQWvwRubAte/IorJfvoj2P4j/pk1MrMb+19FFGeRCb
rE1H12uJYP88PiZOxtdEdtnlBiR06pI4kOWVvjv6lHhlsTg9y3BUxyXPB8ydzNV8
wDqkPQPnFkQSQ1kHpNYomcmBw8izoTojjglpL3ifcpeuWQFzMKWJ6PFpA/236e/k
7WOpgp2FcF8ZuWaoGsq8n+QhTmac78P3LjYqBiEaq0KdaKRBppIkOTC6IJkVoe49
2PK+nPjCpq6HzTzw6hCrNGmPn++2ryJkiJKuIdor38SRRhuV4EA=
=snQJ
-----END PGP SIGNATURE-----

--Sig_/.XCJlYJqF5QI/5Sz1Tc2Qnf--

